require "../src/packetz"

capture = Packetz.capture

puts capture.snapshot_length

capture.snapshot_length = 31337

puts capture.snapshot_length
