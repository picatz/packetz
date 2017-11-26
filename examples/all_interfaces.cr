require "../src/packetz"

#puts Packetz.interfaces.all

Packetz.interfaces.all do |interface|
  puts interface
end
