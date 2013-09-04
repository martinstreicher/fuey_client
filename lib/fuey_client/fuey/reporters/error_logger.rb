require "fuey_client/fuey/log"

module Fuey
  module Reporters
    class ErrorLogger
      def update(status)
        if status[:status] == 'failed'
          Log.alert "#{status[:name]} failed. #{status[:statusMessage]}"
        end
      end
    end
  end
end
