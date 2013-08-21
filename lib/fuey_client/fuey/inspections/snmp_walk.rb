require "fuey_client/fuey/inspections/support/shell_command"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class SNMPWalk < Fuey::Inspections::Inspection
      attr_accessor :ip, :agent, :oid, :version, :community, :response

      def initialize(args)
        super(args)
        @version ||= "v1"
        @community ||= "public"
        @status_message = ""
      end

      def execute
        change_status_to "executing"
        response = Support::ShellCommand.new(snmp_walk_command).execute
        result = (response =~ /#{ip}/)
        change_status_to(result ? "passed" : "failed")
        result
      end

      def status_message
        return %(Pending #{snmp_walk_command}) if response.nil?
        %(SNMPWalk #{@_status ? "passed" : "failed"} due to #{response})
      end

      def status
        {
          :settings => snmp_walk_command,
          :statusMessage => status_message
        }.merge(super)
      end

      def to_s
        snmp_walk_command
      end

      def snmp_walk_command
        %(snmpwalk -#{@version} -c #{@community} #{@agent} #{@oid})
      end
      private :snmp_walk_command

    end
  end
end
