require 'spec_helper'

describe Fuey::Inspections::Inspection do

  describe "observing an inspection" do

    class TestInspection < Fuey::Inspections::Inspection
      def execute
        change_status_to "executing"
        change_status_to "passed"
        return true
      end
    end
    Given(:inspection) { TestInspection.new({ :name => 'Example' }) }
    Given(:subscriber) { double "Observer" }

    describe "while executing" do
      Given { subscriber.
        should_receive(:update).
        with({
               :type => 'TestInspection',
               :name => 'Example',
               :status => 'executing'
             }) }
      Given { subscriber.
        should_receive(:update).
        with({
               :type => 'TestInspection',
               :name => 'Example',
               :status => 'passed'
             }) }
      Given { inspection.add_observer subscriber }
      Then { expect( inspection.execute ).to be_true }
    end

  end

end
