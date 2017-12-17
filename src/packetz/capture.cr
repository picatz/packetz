module Packetz
  # The `Capture` class is responsible for all of the supported capturing operations provided 
  # by `LibPcap` in a clean, friendly API.
  # 
  # Simply start a new capture object called `cap`, with all the defaults:
  # ```
  # cap = Packetz::Capture.new
  # ```
  # 
  # If you want to start customizing the capture object during initialization, you have a few
  # ways to do that to change the `interface`, `snapshot_length`, `promiscuous_mode` and `timeout_ms` values
  # of a capture.
  #
  # Listen specifically on the `en0` network interface: 
  # ```
  # cap = Packetz::Capture.new("en0")
  # ```
  #
  # Listen with alll the default options, but in promiscuous mode:
  # ```
  # cap = Packetz::Capture.new(promiscuous_mode = true)
  # ```
  # 
  # Change the default snapshot length from `65535` to half that size.
  # ```
  # cap = Packetz::Capture.new(snapshot_length: 65535/2)
  # ```
  class Capture
    # The `#initialize` method takes care of setting up a **new** `Capture` object.  
    def initialize(@interface        : String = Packetz.interfaces.default, 
                   @snapshot_length  = 65535, 
                   @promiscuous_mode : Bool | Int32 = 0, 
                   @timeout_ms       = 1, 
                   @monitor_mode     = false)
      err      = LibPcap::PCAP_ERRBUF_SIZE.dup
      @handle  = LibPcap.pcap_create(@interface, pointerof(err))
      @stopped = true
      # need to actually set the given information with the C API
      self.timeout_ms       = @timeout_ms
      self.snapshot_length  = @snapshot_length
      self.promiscuous_mode = @promiscuous_mode
      self.monitor_mode     = @monitor_mode
      # some automatic cleanup for lazy
      at_exit { stop! unless stopped? } 
    end

    # Handles activating the actual packet capturing.
    def start!
      case LibPcap.pcap_activate(@handle)
      when 0
        @stopped = false
        true
      else
        # TODO: Document all errors
        false
      end
    end

    # Provides access to underlying interface string.
    def interface
      @interface
    end

    # Set the network interface to a given string.
    def interface=(interface : String)
      err = LibPcap::PCAP_ERRBUF_SIZE.dup
      @handle = LibPcap.pcap_create(@interface, pointerof(err))
      self.timeout_ms       = self.timeout_ms
      self.snapshot_length  = self.snapshot_length
      self.promiscuous_mode = self.promiscuous_mode
      self.monitor_mode     = self.monitor_mode
    end

    def reset!
      self.interface = self.interface
    end

    def stop!
      LibPcap.pcap_close(@handle)
      @stopped = true
    end

    def stopped?
      @stopped || false
    end

    def started?
      ! self.stopped?
    end

    def each
      loop do
        result = LibPcap.pcap_next_ex(@handle, out pkt_header, out pkt_data)
        case result
        when 1 # success
          yield pkt_data.to_slice(pkt_header.value.caplen), pkt_header.value
        when 0 # timeout
          next
        end
      end
    end

    def next
      raise Exception.new "Capture has been stopped!" if stopped?
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
        raise Exception.new "Something went terribly wrong trying to enable monitor mode quickly!"
      end
    end 
    
    def monitor_mode=(value : Bool)
      case value
      when true
        self.enable_monitor_mode!
        @monitor_mode = true
      when false
        case LibPcap.pcap_set_rfmon(@handle, 0)
        when 0
          @monitor_mode = false
          true
        else
          raise Exception.new "Something went terribly wrong trying to enable monitor mode manually!"
        end
      end
    end

    def monitor_mode
      @monitor_mode
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
        raise Exception.new "Promiscuous mode operation can't be performed on already activated captures."
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
    
    def promiscuous_mode!
      self.promiscuous_mode = 1
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
        raise Exception.new "Timeout operation can't be performed on already activated captures."
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

    def immediate_mode=(value : Int32)
      case LibPcap.pcap_set_immediate_mode(@handle, value)
      when 0
        @immediate_mode = true
        true
      when -4
        raise Exception.new "Operation can't be performed on already activated captures."
      end
    end
    
    def immediate_mode!
      self.immediate_mode = 1
    end
    
    def immediate_mode=(value : Bool)
      case value
      when true
        self.immediate_mode = 1
      when false
        self.immediate_mode = 0
      end
    end

    def immediate_mode?
      @immediate_mode || false
    end

    def non_blocking_mode=(value : Int32)
      err = LibPcap::PCAP_ERRBUF_SIZE.dup
      case LibPcap.pcap_setnonblock(@handle, value, pointerof(err))
      when 0
        @non_blocking_mode = true
        true
      when -1
        err
      end
    end

    def non_blocking_mode!
      self.non_blocking_mode = 1
    end

    def non_blocking_mode=(value : Bool)
      case value
      when true
        self.non_blocking_mode = 1
      when false
        self.non_blocking_mode = 0
      end
    end
    
    def non_blocking_mode?
      @non_blocking_mode || false
    end
    
    def monitor_mode?
      @monitor_mode || false
    end

  end
end
