require "spec_helper"
require "timecop"

describe Fuey::Inspections::Key do

  context "today is Sept 5, 2013 at noon thirty" do
    Given { Timecop.freeze Time.local(2013,9,5,12,30,0) }
    Given (:trace) { Fuey::Trace.new :name => "My Trace" }
    Given (:inspection) { Fuey::Inspections::Ping.new :name => "Ping Google" }
    When  (:key) { Fuey::Inspections::Key.new trace, inspection }
    Then { expect( key.to_s ).to eql("my_trace-ping_google-20130905123000") }
  end

  context "today is Jan 20, 2012 at one thirty" do
    Given { Timecop.freeze Time.local(2012,1,20,13,30,8) }
    Given (:trace) { Fuey::Trace.new :name => "Another Trace" }
    Given (:inspection) { Fuey::Inspections::Ping.new :name => "Ping Amazon" }
    When  (:key) { Fuey::Inspections::Key.new trace, inspection }
    Then { expect( key.to_s ).to eql("another_trace-ping_amazon-20120120133008") }
  end

end
