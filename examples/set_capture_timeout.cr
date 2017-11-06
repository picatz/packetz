require "../src/packetz"

capture = Packetz.capture

puts capture.timeout_ms

capture.timeout_ms = 2

puts capture.timeout_ms
