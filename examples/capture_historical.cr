require "../src/packetz"

err1 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup

iface = String.new(Packetz::LibPcap.pcap_lookupdev(pointerof(err1)))

err2 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup

capture = Packetz::LibPcap.pcap_open_live(iface, 65535, 0, 1, pointerof(err2))

while true
  result = Packetz::LibPcap.pcap_next_ex(capture, out pkt_header, out pkt_data)
  next unless result == 1
  data = pkt_data.to_slice(pkt_header.value.caplen)
  puts data.hexdump
end
