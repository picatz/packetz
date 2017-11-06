require "../src/packetz"

default_interface = Packetz.interfaces.default

all_interfaces = Packetz.interfaces.all

Packetz.interfaces.each do |interface|
  puts "#{interface}" if Packetz.interfaces.supports_monitor_mode?(interface)
end
