require "net/ping"

module Fuey
  module Inspections
    class Ping < Fuey::Inspections::Inspection
      attr_accessor :host, :result

      def _execute
        result = Net::Ping::External.new(@host).ping
        if result
          self.pass
        else
          self.fail
        end
      end

      def to_s
        %(Ping #{name} #{host})
      end

      def status
        {
          :settings => host || "",
          :statusMessage => %(#{state} ping for #{host}),
        }.merge(super)
      end
    end
  end
end
