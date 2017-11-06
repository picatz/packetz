require "../src/packetz"

Packetz.capture do |packet|
  puts packet.hexdump
end
