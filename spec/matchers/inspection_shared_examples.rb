shared_examples "an inspection" do
  describe "should initialize with a hash" do
    Then { expect( described_class.new({}) ).to be_a(described_class) }
  end

  describe "should respond to #execute" do
    Then { expect( described_class.new({}) ).to respond_to(:execute) }
  end
end
