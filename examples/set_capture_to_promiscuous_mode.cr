require "../src/packetz"

capture = Packetz.capture

puts capture.promiscuous_mode

capture.promiscuous_mode = true

puts capture.promiscuous_mode?
