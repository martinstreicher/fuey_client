require 'spec_helper'

describe Fuey::Inspections::Inspection do

  def successful_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.pass
      end
    end
  end

  def failed_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.fail
      end
    end
  end


  describe "execution" do
    describe "with an observer" do
      Given(:subscriber) { double "Observer", :update => nil }
      Given { subscriber.
        should_receive(:update).
        with({
               :type => inspection.class.to_s,
               :name => 'Example',
               :status => 'pending'
             }) }
      Given { subscriber.
        should_receive(:update).
        with({
               :type => inspection.class.to_s,
               :name => 'Example',
               :status => 'executed'
             }) }

      context "when it fails" do
        Given(:inspection) { failed_inspection.new({ :name => 'Example' }) }
        Given { inspection.add_observer subscriber }

        Given { subscriber.
          should_receive(:update).
          with({
                 :type => inspection.class.to_s,
                 :name => 'Example',
                 :status => 'failed'
               }) }

        When  { inspection.execute }
        Then  { expect( inspection ).to be_failed }
      end

      context "when it passes" do
        Given(:inspection) { successful_inspection.new({ :name => 'Example' }) }
        Given { inspection.add_observer subscriber }

        Given { subscriber.
          should_receive(:update).
          with({
                 :type => inspection.class.to_s,
                 :name => 'Example',
                 :status => 'passed'
               }) }
        When  { inspection.execute }
        Then  { expect( inspection ).to be_passed }
      end
    end
  end

  describe "it's state" do
    Given (:inspection) { Fuey::Inspections::Inspection.new }

    context "initially" do
      Then { expect( successful_inspection.new.state ).to eql('pending') }
      Then { expect( failed_inspection.new.state ).to eql('pending') }
    end

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
