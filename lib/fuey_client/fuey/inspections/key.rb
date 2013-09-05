module Fuey
  module Inspections
    class Key

      def initialize(trace, inspection)
        @_key = [
                 t( trace.name ),
                 t( inspection.name ),
                 Time.now.strftime("%Y%m%d%H%M%S")
                ].join('-')
      end

      def to_s
        @_key
      end

      def t(string)
        string.downcase.gsub(/[^a-z0-9\-_]+/, "_")
      end
      private :t
    end
  end
end
