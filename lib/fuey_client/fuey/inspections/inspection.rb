require "observer"

module Fuey
  module Inspections
    class Inspection
      include ModelInitializer
      include Observable

      attr_accessor :name

      def initialize(args)
        super(args)
        @_status = "pending"
      end

      def status
        {
          :type => self.class.to_s.split('::').last,
          :name => name,
          :status => @_status
        }
      end

      def change_status_to(new_status)
        changed
        @_status = new_status
        notify_observers status
      end
      protected :change_status_to
    end
  end
end
