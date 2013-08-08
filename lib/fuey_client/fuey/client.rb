require "fuey_client/fuey/log"
require "fuey_client/fuey/config"
require "fuey_client/fuey/inspections"
require "net/ping"

module Fuey
  class Client
    def run
      Config.inspections.pings.map{|name, host| Inspections::Ping.new(name, host) }.each do |ping|
        ping.execute
      end

      0
    rescue => caught
      if (caught.message =~ /is not configured/)
        Log.write "Nothing configured."
        return 0
      else
        Log.write caught.message
        return 1
      end
    end
  end
end
