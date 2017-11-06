require "../src/packetz"

capture = Packetz.capture

capture.enable_monitor_mode! if capture.supports_monitor_mode?

capture.start!

capture.each do |packet|
  puts packet.hexdump
end
