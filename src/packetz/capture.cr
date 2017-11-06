module Packetz
  class Capture
    def initialize(interface : String = Packetz.interfaces.default, snapshot_length = 65535, promiscuous_mode = 0, timeout_ms = 1)
      @interface = interface
      err = LibPcap::PCAP_ERRBUF_SIZE.dup
      @timeout_ms = timeout_ms 
      @handle = LibPcap.pcap_create(@interface, pointerof(err))
      @closed = true
      at_exit { LibPcap.pcap_close(@handle) unless closed? } 
      self.snapshot_length = snapshot_length
      self.promiscuous_mode = promiscuous_mode
    end

    def start!
      case LibPcap.pcap_activate(@handle)
      when 0
        @closed = false
        true
      else
        # TODO: Document all errors
        false
      end
    end

    def close
      LibPcap.pcap_close(@handle)
      @closed = true
    end

    def closed?
      @closed || false
    end

    def each
      loop do
        result = LibPcap.pcap_next_ex(@handle, out pkt_header, out pkt_data)
        case result
        when 1 # success
          yield pkt_data.to_slice(pkt_header.value.caplen)
        when 0 # timeout
          next
        else
          raise Exception.new "Something went terribly wrong!"
        end
      end
    end

    def next
      raise Exception.new "Capture has been closed!" if closed?
      result = LibPcap.pcap_next_ex(@handle, out pkt_header, out pkt_data)
      { result: result, header: pkt_header, data: pkt_data }
    end

    def supports_monitor_mode?
      Packetz.interfaces.supports_monitor_mode?(@interface)
    end

    def enable_monitor_mode!
      case LibPcap.pcap_set_rfmon(@handle, 1)
      when 0
        true
      else
        # TODO: document erors
        raise Exception.new "Something went terribly wrong!"
      end
    end 

    def snapshot_length
      @snapshot_length
    end

    def snapshot_length=(value : Int32)
      case LibPcap.pcap_set_snaplen(@handle, value)
      when 0
        @snapshot_length = value
        true
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def snapshot_length
      @snapshot_length
    end
    
    def promiscuous_mode=(value : Bool)
      case value
      when true
        self.promiscuous_mode = 1
      when false
        self.promiscuous_mode = 0
      end
    end

    def promiscuous_mode=(value : Int32)
      case LibPcap.pcap_set_promisc(@handle, value)
      when 0
        @promiscuous_mode = value 
        true
      when -4 
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def promiscuous_mode
      case @promiscuous_mode
      when 1
        true
      when 0
        false
      end
    end

    def promiscuous_mode?
      promiscuous_mode
    end

    def timeout_ms
      @timeout_ms
    end

    def timeout_ms=(value : Int32)
      @timeout_ms = value
      case LibPcap.pcap_set_timeout(@handle, value)
      when 0
        true
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def timestamp_precision
      case LibPcap.pcap_get_tstamp_precision(@handle)
      when 0
        :microsecond
      when 1
        :nanosecond
      end
    end

    def microsecond_timestamp_precision?
      case self.timestamp_precision
      when :microsecond
        true
      else
        false
      end
    end
    
    def nanosecond_timestamp_precision?
      case self.timestamp_precision
      when :nanosecond
        true
      else
        false
      end
    end

    def microsecond_timestamp_precision!
      case LibPcap.pcap_set_tstamp_precision(@handle, 0)
      when 0
        true
      when -12
        raise Exception.new "Requested time stamp precision is not supported!"
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def nanosecond_timestamp_precision!
      case LibPcap.pcap_set_tstamp_precision(@handle, 1)
      when 0
        true
      when -12
        raise Exception.new "Requested time stamp precision is not supported!"
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def immediate_mode!
      case LibPcap.pcap_set_immediate_mode(@handle, 1)
      when 0
        @immediate_mode = true
        true
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end

    def immediate_mode?
      @immediate_mode || false
    end

  end
end
