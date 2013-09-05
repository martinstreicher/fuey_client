require "json"
require "fuey_client/fuey/redis"


#     Given (:inspection_key) { "my_trace-ping_google-20130804120031" }
#     Time::DATE_FORMATS[:key]  = "%Y%m%d%H%M%S"


module Fuey
  module Reporters
    class NotificationQueue
      def initialize(redis)
        @_redis = redis
      end

      # Handles update from observable
      def update(type, trace_name, statuses)
        if type == :new
          channel = "fuey.trace.new"
          message = {
            :name => trace_name,
            :status => "executed",
            :statusMessage => "",
            :steps => statuses.map(&:attributes)
          }
        else
          channel = "fuey.trace.update"
          message = {
            :name => trace_name,
            :status => statuses.first.status,
            :statusMessage => statuses.first.status,
            :steps => statuses.map(&:attributes)
          }
        end

        @_redis.publish channel, message.to_json
      end
    end
  end
end
