require 'net/ping'

module Fuey
  module Inspections
    class Ping
      def initialize(name, host)
        @host = host
      end

      def execute
        result = Net::Ping::External.new(@host).ping
        Log.write "Pinging #{@host} #{result ? 'failed' : 'succeeded'}."
        result
      end
    end
  end
end
