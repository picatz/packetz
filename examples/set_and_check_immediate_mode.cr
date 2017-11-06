require "../src/packetz"

capture = Packetz.capture

capture.immediate_mode!

puts capture.immediate_mode?
