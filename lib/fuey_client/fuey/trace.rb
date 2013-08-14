require "active_model"

module Fuey
  class Trace
    include ActiveModel::Model

    attr_accessor :name, :steps

    def initialize(args)
      super(args)
      @steps ||= Array.new
    end

    def self.all
      Config.traces.keys.map do |trace_name|
        trace = Trace.new :name => trace_name
        Config.traces.send(trace_name).each do |step|
          inspection = ActiveSupport::Inflector.constantize %(Fuey::Inspections::#{step.keys.first})
          trace.steps.push inspection.new(step.values.first)
        end
        trace
      end

    end

  end
end
