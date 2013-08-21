require "fuey_client/fuey/model_initializer"
require "active_support"
require "observer"

module Fuey
  class Trace
    include ModelInitializer
    include Observable

    attr_accessor :name, :steps

    def initialize(args)
      super(args)
      @steps ||= Array.new
    end

    def self.all
      Config.traces.keys.map do |trace_name|
        trace = Trace.new :name => trace_name
        Config.traces.send(trace_name).each do |step|
          inspection_class = ActiveSupport::Inflector.constantize %(Fuey::Inspections::#{step.keys.first})
          inspection = inspection_class.new(step.values.first)
          inspection.add_observer(trace)
          trace.steps.push inspection
        end
        trace
      end
    end

    def to_s
      %(#{name}: [#{steps.join(', ')}])
    end

    # Handle updates from inpsections via observation
    def update(status)
      changed
      notify_observers(
                       "fuey.trace.update",
                       {
                         :name => name,
                         :statusMessage => status[:statusMessage],
                         :steps => [ status ]
                       })
    end

    def run
      changed
      notify_observers(
                       "fuey.trace.new",
                       {
                         :name => name,
                         :statusMessage => "executing",
                         :steps => steps.map(&:status)
                       }
                       )
      ActiveSupport::Notifications.instrument("run.trace", {:trace => self.to_s}) do
        run, failed, current = 0, 0, ""
        steps.each do |step|
          run += 1
          current = step.name
          if step.execute
          else
            failed += 1
            break
          end
        end
        if failed == 0
          %(#{name} passed. #{steps.size} steps, #{run} executed, #{failed} failed.)
        else
          %(#{name} failed on #{current}. #{steps.size} steps, #{run} executed, #{failed} failed.)
        end
      end
    end
  end
end
