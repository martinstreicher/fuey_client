require "json"
require "fuey_client/fuey/redis"
require "fuey_client/fuey/inspections/key"

module Fuey
  module Reporters
    class NotificationQueue
      def initialize(redis)
        @_redis = redis
      end

      def update(type, trace_name, statuses)
        self.send("publish_#{type}", trace_name, statuses)
        true
      end

      def publish_update(trace_name, statuses)
        message = [ trace_name, statuses.first.attributes ]
        @_redis.publish "fuey.trace.update", message.to_json
      end

      def publish_new(trace_name, statuses)
        message = {
            :name => trace_name,
            :status => "executed",
            :status_message => "",
            :steps => statuses.map(&:attributes)
        }
        @_redis.publish "fuey.trace.new", message.to_json
      end
    end
  end
end
