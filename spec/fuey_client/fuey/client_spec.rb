require "spec_helper"

describe Fuey::Client do

  describe "#run" do
    context "when nothing is configured" do
      Given { Fuey::Log.should_receive(:write).with("Exited after inspecting nothing.") }
      Given { Fuey::Config.stub(:inspections).and_return([]) }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(0) }
    end
  end

end
