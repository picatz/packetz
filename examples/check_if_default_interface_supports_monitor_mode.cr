require "../src/packetz"

err1 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup

iface = Packetz::LibPcap.pcap_lookupdev(pointerof(err1))

err2 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup

live = Packetz::LibPcap.pcap_create(iface, pointerof(err2))

at_exit { Packetz::LibPcap.pcap_close(live) } 

case Packetz::LibPcap.pcap_can_set_rfmon(live)
when 1
  puts true
when 0
  puts false
  exit 1
end
