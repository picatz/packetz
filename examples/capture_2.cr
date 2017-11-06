require "../src/packetz"

capture = Packetz.capture

at_exit { Packetz.close(capture) } 

while true
  result = Packetz::LibPcap.pcap_next_ex(capture, out pkt_header, out pkt_data)
  next unless result == 1
  data = pkt_data.to_slice(pkt_header.value.caplen)
  puts data.hexdump
end
