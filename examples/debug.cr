require "../src/packetz"

capture = Packetz.capture

capture.immediate_mode!
capture.promiscuous_mode = true
capture.start!

capture.each do |packet|
  puts packet.hexdump
end
