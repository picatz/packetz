module Packetz
  module Interfaces
    def self.default
      err = LibPcap::PCAP_ERRBUF_SIZE.dup
      String.new(LibPcap.pcap_lookupdev(pointerof(err)))
    end

    def self.all
      err = LibPcap::PCAP_ERRBUF_SIZE.dup
      result = LibPcap.pcap_findalldevs(out iface_iterator, pointerof(err)) 
      if result == -1
        raise Exception.new "Unable to find devices! #{err}"
      end
      interfaces = [] of String
      orig  = iface_iterator
      iface = iface_iterator
      until iface_iterator.null?
        iface = iface_iterator.value
        interfaces << String.new(iface.name)
        iface_iterator = iface.next
      end
      LibPcap.pcap_freealldevs(orig)
      interfaces 
      # fix bug, probably temporarily
      interfaces.shift
      [Packetz.interfaces.default] + interfaces
    end

    def self.each
      Packetz.interfaces.all.each do |interface|
        yield interface
      end
    end

    # Check if a given interface supports monitor mode.
    def self.supports_monitor_mode?(interface : String)
      err1 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup
      iface = Packetz::LibPcap.pcap_lookupdev(pointerof(err1))
      err2 = Packetz::LibPcap::PCAP_ERRBUF_SIZE.dup
      live = Packetz::LibPcap.pcap_create(iface, pointerof(err2))
      begin
        case Packetz::LibPcap.pcap_can_set_rfmon(live)
        when 1
          return true
        when 0
          return false
        end
      ensure
        Packetz::LibPcap.pcap_close(live)
      end
    end
  end
end
