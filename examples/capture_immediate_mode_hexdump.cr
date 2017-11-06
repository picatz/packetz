require "../src/packetz"

capture = Packetz.capture

capture.immediate_mode!

capture.start!

capture.each do |packet|
  puts packet.hexdump
end
