module Fuey
  module Inspections
    class Inspection
      include ModelInitializer

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
    end
  end
end
