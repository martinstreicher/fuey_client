require "net/ping"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class Ping < Fuey::Inspections::Inspection
      attr_accessor :host

      def execute
        change_status_to "executing"
        result = Net::Ping::External.new(@host).ping
        Log.write "[#{@name}] Pinging #{@host} #{result ? 'succeeded' : 'failed'}."
        change_status_to(result ? "passed" : "failed")
        result
      end

      def to_s
        %(Ping #{name} #{host})
      end

      def status
        {
          :settings => host || "",
          :statusMessage => ""
        }.merge(super)
      end
    end
  end
end
