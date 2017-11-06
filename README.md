# 🦈  Packetz

Packet capturing library built with [LibPcap](https://github.com/the-tcpdump-group/libpcap).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  packetz:
    github: picatz/packetz
```

## Usage

```crystal
require "packetz"

# start packet capture on default interface
Packet.capture do |packet|
  puts packet.hexdump
end
```

```crystal
# get default interface to capture on
Packetz.default_interface
```

```crystal
# get all possible interfaces
Packetz.all_interfaces do |interface|
  puts interface
end
```

## Contributors

- [picat](https://github.com/picatz) Kent 'picat' Gruber - creator, maintainer
- [maiha](https://github.com/maiha) maiha - `pcap.cr`
- [puppetpies](https://github.com/puppetpies) Brian Hood - `libpcap.cr`
