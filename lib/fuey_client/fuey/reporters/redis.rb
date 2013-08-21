require "redis"
require "json"

module Fuey
  module Reporters
    class Redis
      def redis
        @@redis ||= ::Redis.new
      end

      # Handles update from observable
      def update(channel, message)
        redis.publish channel, message.to_json
      end
    end
  end
end
