require "../src/packetz"

Packetz.capture do |packet|
  packet = Packetz::Parsers::Ethernet.new(packet) 
  puts "#{packet.source} -> #{packet.destination} [#{packet.type}]"
end
