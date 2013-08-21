require "net/ping"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class Ping < Fuey::Inspections::Inspection
      attr_accessor :host, :result

      def execute
        change_status_to "executing"
        result = Net::Ping::External.new(@host).ping
        change_status_to(result ? "passed" : "failed")
        result
      end

      def to_s
        %(Ping #{name} #{host})
      end

      def status_message
        return "Pending ping for #{host}" if result.nil?
         %(Pinging #{host} #{result ? 'succeeded' : 'failed'}.)
      end

      def status
        {
          :settings => host || "",
          :statusMessage => status_message
        }.merge(super)
      end
    end
  end
end
