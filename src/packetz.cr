require "./packetz/*"

module Packetz
  def self.interfaces
    Interfaces
  end

  def self.capture(interface = Packetz.interfaces.default, snaplen = 65535, promisc = 0, timeout_ms = 1)
    Capture.new(interface, snaplen, promisc, timeout_ms)
  end
end
