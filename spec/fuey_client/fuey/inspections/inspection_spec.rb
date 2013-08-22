require 'spec_helper'

describe Fuey::Inspections::Inspection do

  describe "observing an inspection" do

    class TestInspection < Fuey::Inspections::Inspection
      def _execute
        self.pass
      end
    end
    Given(:inspection) { TestInspection.new({ :name => 'Example' }) }
    Given(:subscriber) { double "Observer" }

    describe "and it's initial state" do
      Then { expect( inspection.state ).to eql('pending') }
    end

    describe "while executing" do
      Given { subscriber.
        should_receive(:update).
        with({
               :type => 'TestInspection',
               :name => 'Example',
               :status => 'pending'
             }) }
      Given { subscriber.
        should_receive(:update).
        with({
               :type => 'TestInspection',
               :name => 'Example',
               :status => 'executed'
             }) }
      Given { subscriber.
        should_receive(:update).
        with({
               :type => 'TestInspection',
               :name => 'Example',
               :status => 'passed'
             }) }
      Given { inspection.add_observer subscriber }
      When  { inspection.execute }
      Then  { expect( inspection ).to have_passed }
    end
  end

  describe "inspecting state" do
    Given (:inspection) { Fuey::Inspections::Inspection.new }

    context "when the inspection passes" do
      When  { inspection.pass }
      Then  { expect( inspection ).to be_passed }
    end

    context "when the inspection fails" do
      When  { inspection.fail }
      Then  { expect( inspection ).to be_failed }
    end
  end
end
