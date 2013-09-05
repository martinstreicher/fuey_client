require "fuey_client/fuey/inspection_repository"
require "fuey_client/fuey/model_initializer"
require "fuey_client/fuey/reporters"
require "active_support"
require "observer"

module Fuey
  class Trace
    include ModelInitializer
    include Observable

    attr_accessor :name

    def initialize(args)
      super(args)
    end

    def receiver=(observer)
      add_observer observer
    end

    def add_step(inspection)
      inspection.add_observer(self)
      inspection.add_observer(error_logger)
      steps.push inspection
      inspection
    end

    def steps
      @_steps ||= Array.new
    end

    def error_logger
      @_error_logger ||= Fuey::Reporters::ErrorLogger.new
    end
    private :error_logger

    def to_s
      %(#{name}: [#{steps.join(', ')}])
    end

    # Handle updates from inpsections via observation
    def update(step_status)
      changed
      notify_observers "fuey.trace.update", wrap_with_trace(step_status)
      InspectionRepository.add(name, step_status) if step_status[:status] =~ /passed|failed/
      true
    end

    def wrap_with_trace(status)
      {
        :name => name,
        :status => status[:status],
        :statusMessage => status[:statusMessage],
        :steps => [ status ]
      }
    end
    private :wrap_with_trace

    def run
      changed
      notify_observers(
                       "fuey.trace.new",
                       {
                         :name => name,
                         :status => "executed",
                         :statusMessage => "",
                         :steps => steps.map(&:status)
                       }
                       )
      ActiveSupport::Notifications.instrument("run.trace", {:trace => self.to_s}) do
        run, failed, current = 0, 0, ""
        steps.each do |step|
          run += 1
          current = step.name
          step.execute
          if step.failed?
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
