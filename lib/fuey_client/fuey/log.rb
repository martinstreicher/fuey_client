require "fuey_client/fuey/config"
require 'logger'

module Fuey
  class Log
    def self.write(message)
      logger.info "[#{Config.title}] #{message}"
    end

    def self.logger
      @@logger ||= Logger.new Config.logfile, 'daily'
    end
    private_class_method :logger
  end
end
