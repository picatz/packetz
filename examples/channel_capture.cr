require "../src/packetz"

Signal::INT.trap do
  puts "Stopping!"
  exit
end

channel = Channel(String).new

spawn do
  Packetz.capture do |packet|
    channel.send packet.hexdump
  end
end

10.times do
  puts channel.receive
end
