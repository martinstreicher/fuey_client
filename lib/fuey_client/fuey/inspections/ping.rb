require 'net/ping'

module Fuey
  module Inspections
    class Ping
      def initialize(name, host)
        @host = host
        @name = name
      end

      def execute
        result = Net::Ping::External.new(@host).ping
        Log.write "[#{@name}] Pinging #{@host} #{result ? 'succeeded' : 'failed'}."
        result
      end
    end
  end
end
