require "fuey_client/fuey/inspections/support/shell_command"

module Fuey
  module Inspections
    class SNMPWalk

      def initialize(title, ip, agent, oid, version='v1',community='public')
        @title = title
        @ip = ip
        @oid = oid
        @agent = agent
        @version = version
        @community = community
      end

      def execute
        result = Support::ShellCommand.new("snmpwalk -#{@version} -c #{@community} #{@agent} #{@oid}").execute
        result = result =~ /#{@ip}/
        Log.write "[#{@title}] SNMPWalk for #{@ip} using #{@agent} #{result ? 'succeeded' : 'failed' }."
        result
      end

    end
  end
end
