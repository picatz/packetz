require "../src/packetz"

capture = Packetz.capture

capture.promiscuous_mode!

puts capture.promiscuous_mode?
