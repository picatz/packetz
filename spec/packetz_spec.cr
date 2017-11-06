require "./spec_helper"

describe Packetz do
  #it "can lookup the default inteface" do
  #  iface = Packetz::Pcap.default_interface
  #  iface.should eq("en0")
  #end
  #it "can lookup all capture intefaces" do
  #  ifaces = Packetz::Pcap.all_interfaces
  #  ifaces.first.should eq("en0")
  #end
  #it "can start/close a capture" do
  #  live = Packetz::Pcap.capture
  #  Packetz::Pcap.close(live).should eq(true)
  #end
  #it "can get a packet" do
  #  live = Packetz::Pcap.capture
  #  Packetz::Pcap.close(live)
  #end
  it "can start/close a capture" do
    live = Packetz::Capture.new
    live.close
    live.closed?.should eq(true)
  end
  it "can get a packet from a capture" do
    live = Packetz::Capture.new
    live.loop do |pkt|
      puts pkt
    end
    live.closed?.should eq(true)
  end
end
