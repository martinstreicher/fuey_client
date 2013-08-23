require "observer"
require "stately"
require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    class Inspection
      include ModelInitializer
      include Observable

      attr_accessor :name, :state

      stately :start => :pending, :attr => :state do
        state :executed, :action => :execute  do
          before_transition :do => :notify
          after_transition :do => :notify
          after_transition :do => :_execute
        end
        state :passed, :action => :pass do
          after_transition :do => :notify
        end
        state :failed, :action => :fail do
          after_transition :do => :notify
        end
      end

      def passed?
        state == 'passed'
      end

      def failed?
        state == 'failed'
      end

      def notify
        changed
        notify_observers status
      end

      def status
        {
          :type => self.class.to_s.split('::').last,
          :name => name,
          :status => self.state
        }
      end

    end
  end
end
