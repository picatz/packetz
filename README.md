# 🦈  Packetz

Packet capturing library built with [LibPcap](https://github.com/the-tcpdump-group/libpcap).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  packetz:
    github: picatz/packetz
```

## Basic Usage

```crystal
require "packetz"

# start packet capture on default interface
Packetz.capture do |packet|
  puts packet.hexdump
end
```

#### Craft your Capture

```crystal
# create capture handler
cap = Packetz.capture

# stop the capture with ctl+C
Signal::INT.trap do
  puts "Stopping!"
  cap.stop!
  exit
end

# setup the handler
cap.snapshot_length  = 33333
cap.promiscuous_mode = true
cap.monitor_mode     = true

# start capturing
cap.start!

# do something with each packet and its pcap header
cap.each do |packet, pcap_header|
  # something
end
```

#### Network Interfaces

```crystal
# get default interface to capture on
Packetz.interfaces.default
```

```crystal
# get all possible interfaces
Packetz.interfaces.all do |interface|
  puts interface
end
```

## Contributors

- [picat](https://github.com/picatz) Kent 'picat' Gruber - creator, maintainer
- [maiha](https://github.com/maiha) maiha - `pcap.cr`
- [puppetpies](https://github.com/puppetpies) Brian Hood - `libpcap.cr`
