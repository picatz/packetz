require "./packetz/*"

module Packetz
  # The `#interfaces` method provides a sweet, syntactic sugar to be able to 
  # access the underlying `Interfaces` module for information about network interfaces.
  # 
  # To get the first, **default** ( non-loopback ) interface name on your system:
  # ```
  # Packetz.interfaces.default
  # # => "eth0"
  # ```
  #
  # To access **all** of the interfaces on your system as an array:
  # ```
  # Packetz.interfaces.all
  # # => ["en0", "lo0", "vboxnet0", "vboxnet1"]
  # ```
  #
  # To enumerate through **each** of the interfaces on your system:
  # ```
  # Packetz.interfaces.each do |interface|
  #   puts interface
  # end
  # ```
  def self.interfaces
    Interfaces
  end

  # The `#capture` method provides a delicious, syntactic sugar to be able to
  # access the underlying `Capture` module to perform live packet captures.
	def self.capture(interface = Packetz.interfaces.default, 
									 snapshot_length = 65535, 
									 promiscuous_mode = false, 
									 timeout_ms = 1,
									 monitor_mode = false)
    Capture.new(interface, snapshot_length, promiscuous_mode, timeout_ms, monitor_mode)
  end
 
  # When the `#capture` method is used within a block syntax, then it can quickly start
  # yielding packets to the underlying block. This is an optional way to start capturing 
  # packets right away. 
	def self.capture(interface = Packetz.interfaces.default, 
									 snapshot_length = 65535, 
									 promiscuous_mode = false, 
									 timeout_ms = 1,
									 monitor_mode = false)
    cap = Packetz.capture(interface, snapshot_length, promiscuous_mode, timeout_ms, monitor_mode)
    cap.start!
    cap.each do |packet|
      yield packet
    end
  end
end
