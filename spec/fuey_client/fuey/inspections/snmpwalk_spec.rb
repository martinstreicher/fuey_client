require 'spec_helper'

describe Fuey::Inspections::SNMPWalk do
  it_behaves_like "an inspection"

  describe "#execute" do
    Given (:name) { 'some-tunnel' }
    Given (:oid)   { '1.2.9.2.5.3.5.7.111.0.2.0.1.0' }
    Given (:agent) { '172.16.0.100' }
    Given (:walk_result) {
      <<-WALK
        SNMPv2-SMI::enterprises.3.5.7.111.0.2.0.1.16384 = STRING: "121.240.15.226"
        SNMPv2-SMI::enterprises.3.5.7.111.0.2.0.1.20480 = STRING: "121.42.241.30"
        SNMPv2-SMI::enterprises.3.5.7.111.0.2.0.1.28672 = STRING: "121.48.196.13"
        SNMPv2-SMI::enterprises.3.5.7.111.0.2.0.1.32768 = STRING: "192.180.190.25"
        SNMPv2-SMI::enterprises.3.5.7.111.0.2.0.1.36864 = STRING: "81.197.184.129"
      WALK
    }

    context "when the walk has not been run" do
      Given (:ip) { '172.0.0.1' }
      Given (:snmpwalk) { Fuey::Inspections::SNMPWalk.new(:name => name, :ip => ip, :agent => agent, :oid => oid) }
      Then  { expect( snmpwalk.status_message ).to end_with("snmpwalk -v1 -c public 172.16.0.100 1.2.9.2.5.3.5.7.111.0.2.0.1.0") }
      And   { expect( snmpwalk.status_message ).to start_with("SNMPWalk pending") }
    end

    context "when the walk fails" do
      Given (:ip) { '172.0.0.1' }
      Given { Fuey::Inspections::Support::ShellCommand.stub(:new).with("snmpwalk -v1 -c public 172.16.0.100 1.2.9.2.5.3.5.7.111.0.2.0.1.0").and_return double("ShellCommand", :execute => walk_result) }
      Given (:snmpwalk) { Fuey::Inspections::SNMPWalk.new(:name => name, :ip => ip, :agent => agent, :oid => oid) }
      When  { snmpwalk.execute }
      Then  { expect( snmpwalk ).to have_aborted }
      And   { expect( snmpwalk.status_message ).to end_with(walk_result) }
      And   { expect( snmpwalk.status_message ).to start_with( "SNMPWalk failed" ) }
    end

    context "when the walk succeeds" do
      Given (:ip) { '121.48.196.13' }
      Given { Fuey::Inspections::Support::ShellCommand.stub(:new).with("snmpwalk -v1 -c public 172.16.0.100 1.2.9.2.5.3.5.7.111.0.2.0.1.0").and_return double("ShellCommand", :execute => walk_result) }
      Given (:snmpwalk) { Fuey::Inspections::SNMPWalk.new(:name => name, :ip => ip, :agent => agent, :oid => oid) }
      When  { snmpwalk.execute }
      Then  { expect( snmpwalk ).to have_passed }
      And   { expect( snmpwalk.status_message ).to end_with( "snmpwalk -v1 -c public 172.16.0.100 1.2.9.2.5.3.5.7.111.0.2.0.1.0" ) }
      And   { expect( snmpwalk.status_message ).to start_with( "SNMPWalk passed" ) }
    end

    context "when the walk specifies the version and community" do
      Given (:ip) { '81.197.184.129' }
      Given { Fuey::Inspections::Support::ShellCommand.stub(:new).with("snmpwalk -v3 -c private 172.16.0.100 1.2.9.2.5.3.5.7.111.0.2.0.1.0").and_return double("ShellCommand", :execute => walk_result) }
      Given (:snmpwalk) { Fuey::Inspections::SNMPWalk.new(:name => name, :ip => ip, :agent => agent, :oid => oid, :version => 'v3', :community => 'private') }
      When  { snmpwalk.execute }
      Then  { expect( snmpwalk ).to have_passed }
    end
  end

end
