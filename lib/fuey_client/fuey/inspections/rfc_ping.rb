require "fuey_client/fuey/inspections/support/sap"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class RFCPing
      include ModelInitializer

      attr_accessor :ashost, :sysnr, :client, :user, :passwd, :lang

      def execute
        Support::SAP.new(config).ping
      end

      def to_s
        %(RFC Ping #{ashost} with user #{user})
      end

      def config
        {
          'ashost' => ashost,
          'sysnr' => sysnr,
          'client' => client,
          'user' => user,
          'passwd' => passwd,
          'lang' => lang
        }
      end
      private :config
    end
  end
end
