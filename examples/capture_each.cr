require "../src/packetz"

capture = Packetz.capture

at_exit { Packetz.close(capture) } 

Packetz.each(capture) do |data|
  puts data.hexdump
end
