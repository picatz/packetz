require "../src/packetz"

capture = Packetz.capture

capture.non_blocking_mode!

puts capture.non_blocking_mode?
