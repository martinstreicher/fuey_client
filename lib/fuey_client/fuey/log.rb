require "fuey_client/fuey/config/fuey"
require 'logger'

module Fuey
  class Log
    def self.write(message)
      logger.info "[#{Config::Fuey.title}] #{message}"
    end

    # Handles ActiveSupport::Notifications
    def call(name, started, finished, unique_id, payload)
      Fuey::Log.write %([Event #{name}] Completed in #{finished - started} seconds. #{payload})
    end

    def self.logger
      @@logger ||= Logger.new Config::Fuey.logfile, 'daily'
    end
    private_class_method :logger
  end
end
