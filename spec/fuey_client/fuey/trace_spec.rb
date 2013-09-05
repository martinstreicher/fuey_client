require 'spec_helper'

describe Fuey::Trace do
  describe "receiving updates from inspections" do
    context "when update is reporting it passed" do
      Given (:trace) { Fuey::Trace.new(:name => "My Trace") }
      Given { Fuey::InspectionRepository.should_receive(:add).with("My Trace", status_update).and_return "inspection_key" }
      When (:status_update) {
        {
          :name => 'Ping Google', :status => 'passed', :statusMessage => 'Ping passed.', :type => 'Ping', :settings => '8.8.8.8'
        }
      }
      Then  { expect( trace.update(status_update) ).to be_true }
    end

    context "when update is reporting it executed" do
      Given (:trace) { Fuey::Trace.new(:name => "My Trace") }
      Given { Fuey::InspectionRepository.should_not_receive(:add) }
      When (:status_update) {
        {
          :name => 'Ping Google', :status => 'executed', :statusMessage => 'Ping executed.', :type => 'Ping', :settings => '8.8.8.8'
        }
      }
      Then  { expect( trace.update(status_update) ).to be_true }
    end

    context "when update is reporting it failed" do
      Given (:trace) { Fuey::Trace.new(:name => "My Trace") }
      Given { Fuey::InspectionRepository.should_receive(:add).with("My Trace", status_update).and_return "inspection_key" }
      When (:status_update) {
        {
          :name => 'Ping Google', :status => 'failed', :statusMessage => 'Ping failed.', :type => 'Ping', :settings => '8.8.8.8'
        }
      }
      Then  { expect( trace.update(status_update) ).to be_true }
    end
  end

  describe "running a trace" do
    context "when the first step fails" do
      Given  (:trace) { Fuey::Trace.new :name => "trace1" }
      Given! (:step1) { trace.add_step failed_inspection.new :name => "step1" }
      Given! (:step2) { trace.add_step successful_inspection.new :name => "step2" }
      Given  { step2.should_not_receive(:execute) }
      When   (:result) { trace.run }
      Then   { expect( result ).to eql(%[trace1 failed on step1. 2 steps, 1 executed, 1 failed.]) }
    end

    context "when all steps pass" do
      Given  (:trace) { Fuey::Trace.new :name => "trace1" }
      Given! (:step1) { trace.add_step successful_inspection.new :name => "step1" }
      Given! (:step2) { trace.add_step successful_inspection.new :name => "step2" }
      When   (:result){ trace.run }
      Then   { expect( result ).to eql(%[trace1 passed. 2 steps, 2 executed, 0 failed.]) }
    end
  end

  RSpec::Matchers.define :ping do |name|
    match do |actual|
      (actual.name == name) && (actual.host == @host)
    end

    chain :at do |host|
      @host = host
    end

    failure_message_for_should do
      %(should have pinged #{name} at #{@host}, but was #{actual.name} and #{actual.host})
    end

    failure_message_for_should_not do
      %(should not have pinged #{actual.host})
    end

    description do
      %(should ping #{name} at #{@host})
    end
  end

  def successful_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.pass
      end

      def add_observer(observer)
        # dont observe
      end
    end
  end

  def failed_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.fail
      end

      def add_observer(observer)
        # dont observe
      end
    end
  end

end
