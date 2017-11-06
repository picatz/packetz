require "../src/packetz"

capture = Packetz.capture

begin
  capture.nanosecond_timestamp_precision!
rescue
  # yolo
end

puts capture.default_timestamp_precision?
