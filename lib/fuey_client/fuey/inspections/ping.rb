require 'net/ping'

module Fuey
  module Inspections
    class Ping
      def initialize(name, host)
        @host = host
      end

      def execute
        Net::Ping::External.new(@host).ping
      end
    end
  end
end
