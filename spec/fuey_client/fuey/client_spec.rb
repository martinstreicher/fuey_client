require "spec_helper"

describe Fuey::Client do

  describe "#run" do
    after(:each) { Fuey::Config.reload_configuration }

    context "when nothing is configured" do
      Given { Fuey::Log.should_receive(:write).with("[rspec-test]: Nothing configured.") }
      Given { Fuey::Config.test_with(no_inspections) }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(0) }
    end

    context "when one ping is configured" do
      Given { Fuey::Config.test_with(one_ping) }
      Given (:mock_ping) { double Fuey::Inspections::Ping }
      Given { mock_ping.should_receive(:execute).and_return true }
      Given { Fuey::Inspections::Ping.stub(:new).with("test-server", "0.0.0.1").and_return mock_ping }
      When (:result) { Fuey::Client.new.run }
      Then { expect( result ).to eql(0) }
    end

    context "when two pings are configured" do
      Given { Fuey::Config.test_with(two_pings) }
      Given (:mock_ping) { double Fuey::Inspections::Ping }
      Given { mock_ping.should_receive(:execute).twice.and_return true }
      Given { Fuey::Inspections::Ping.stub(:new).twice.and_return mock_ping }
      When (:result) { Fuey::Client.new.run }
      Then { expect( result ).to eql(0) }
    end

    context "and there is a configuration error" do
      Given { Fuey::Log.should_receive(:write).with("crap") }
      Given { Fuey::Config.stub(:inspections).and_raise(RuntimeError, "crap") }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(1) }
    end
  end

  def no_inspections
    {
      "server_name" => 'rspec-test',
      "inspections" => {}
    }
  end

  def one_ping
    {
      "server_name" => 'rspec-test',
      "inspections" => {
                        "pings" => [
                          ['test-server', '0.0.0.1']
                        ]
      }
    }
  end

   def two_pings
    {
      "server_name" => 'rspec-test',
      "inspections" => {
                        "pings" => [
                                    ['test-server', '0.0.0.1'],
                                    ['vpn-tunnel', '5.5.5.5']
                        ]
      }
    }
  end
end
