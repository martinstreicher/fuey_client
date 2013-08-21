require "fuey_client/fuey/inspections/support/sap"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class RFCPing < Fuey::Inspections::Inspection
      attr_accessor :ashost, :sysnr, :client, :user, :passwd, :lang, :message

      def execute
        change_status_to "executing"
        result, message = Support::SAP.new(config).ping
        change_status_to(result ? "passed" : "failed")
        result
      end

      def to_s
        %(RFC Ping #{ashost} with user #{user})
      end

      def status
        {
          :settings => config.reject{|k,v| k == 'passwd'},
          :statusMessage => message || ""
        }.merge(super)
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
