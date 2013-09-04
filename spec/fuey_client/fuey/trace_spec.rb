require 'spec_helper'

describe Fuey::Trace do
  after(:each) { Fuey::Config::Fuey.reload_configuration }

  describe "retrieving all configured traces" do
    context "when configured for no traces" do
      Given { Fuey::Config::Fuey.test_with(no_traces) }
      When  (:result) { Fuey::Trace.all }
      Then  { expect( result ).to be_empty }
    end

    context "when configured with one trace" do
      Given { Fuey::Config::Fuey.test_with(two_pings) }
      When  (:result) { Fuey::Trace.all }
      Then  { expect( result ).to have(1).items }
      And   { expect( result.first ).to be_a(Fuey::Trace) }
      And   { expect( result.first ).to have(2).steps }
      And   { expect( result.first.steps[0] ).to  ping("Google").at("8.8.8.8") }
      And   { expect( result.first.steps[1] ).to  ping("Self").at("172.0.0.1") }
    end
  end

  #     Given (:inspection_key) { "my_trace-ping_google-20130804120031" }
  #     Time::DATE_FORMATS[:key]  = "%Y%m%d%H%M%S"
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
      Given (:step1) { double(Fuey::Inspections::Ping, :name => "step1", :execute => nil, :failed? => true, :status => {}) }
      Given (:step2) { double(Fuey::Inspections::Ping, :status => {}) }
      Given { step2.should_not_receive(:execute) }
      When  (:result) { Fuey::Trace.new(:name => "trace1", :steps => [step1, step2]).run }
      Then  { expect( result ).to eql(%[trace1 failed on step1. 2 steps, 1 executed, 1 failed.]) }
    end

    context "when all steps pass" do
      Given (:step1) { double(Fuey::Inspections::Ping, :name => "step1", :execute => nil, :failed? => false, :status => {}) }
      Given (:step2) { double(Fuey::Inspections::Ping, :name => "step2", :execute => nil, :failed? => false, :status => {}) }
      When  (:result) { Fuey::Trace.new(:name => "trace1", :steps => [step1, step2]).run }
      Then  { expect( result ).to eql(%[trace1 passed. 2 steps, 2 executed, 0 failed.]) }
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

  def two_pings
    {
      "traces" => {
        "two_pings" =>
        [
         {
           "Ping" => {
             "name" => "Google",
             "host" => "8.8.8.8"
           }
         },
         {
           "Ping" => {
             "name" => "Self",
             "host" => "172.0.0.1"
           }
         }
        ]
      }
    }
  end

  def no_traces
    {
      "traces" => {}
    }
  end
end
