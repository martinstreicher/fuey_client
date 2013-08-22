require 'spec_helper'

describe Fuey::Inspections::Ping do
  it_behaves_like "an inspection"

  describe "#execute" do
    context "when the ping fails" do
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => false) }
      Given (:ping) { Fuey::Inspections::Ping.new(:name => 'some-server', :host => '172.0.0.1') }
      When  { ping.execute }
      Then  { expect( ping ).to have_aborted }
    end

    context "when the ping succeeds" do
      Given { Net::Ping::External.stub(:new).with("172.0.0.1").and_return double("ping", :ping => true) }
      Given (:ping) { Fuey::Inspections::Ping.new(:name => 'some-server', :host => '172.0.0.1') }
      When  { ping.execute }
      Then  { expect( ping ).to have_passed }
    end
  end
end
