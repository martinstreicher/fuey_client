require "net/ping"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class Ping < Fuey::Inspections::Inspection
      attr_accessor :host

      def execute
        result = Net::Ping::External.new(@host).ping
        Log.write "[#{@name}] Pinging #{@host} #{result ? 'succeeded' : 'failed'}."
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
