require 'spec_helper'

describe Fuey::Inspections::Ping do

  describe "#execute" do
    context "when the ping succeeds" do
      Given { Fuey::Log.should_receive(:write).with("Pinging 172.0.0.1 failed.") }
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => true) }
      When  (:result){ Fuey::Inspections::Ping.new('some-server', '172.0.0.1').execute }
      Then  { expect( result ).to eql(true) }
    end

    context "when the ping fails" do
      Given { Fuey::Log.should_receive(:write).with("Pinging 172.0.0.1 succeeded.") }
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => false) }
      When  (:result){ Fuey::Inspections::Ping.new('some-server', '172.0.0.1').execute }
      Then  { expect( result ).to eql(false) }
    end
  end
end
