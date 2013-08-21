require 'spec_helper'

describe Fuey::Inspections::Ping do
  it_behaves_like "an inspection"

  describe "#execute" do
    context "when the ping fails" do
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => false) }
      When  (:result){ Fuey::Inspections::Ping.new(:name => 'some-server', :host => '172.0.0.1').execute }
      Then  { expect( result ).to eql(false) }
    end

    context "when the ping succeeds" do
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => true) }
      When  (:result){ Fuey::Inspections::Ping.new(:name => 'some-server', :host => '172.0.0.1').execute }
      Then  { expect( result ).to eql(true) }
    end
  end
end
