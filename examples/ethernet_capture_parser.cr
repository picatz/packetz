require "../src/packetz"

counter = 0
Packetz.capture do |packet|
  packet = Packetz::Parsers::Ethernet.new(packet) 
  puts "#{packet.source} -> #{packet.destination} [#{packet.type}]"
  sleep 1
  counter += 1
  break if counter == 10
end
