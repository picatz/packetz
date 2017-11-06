module Packetz
	@[Link("pcap")]
	lib LibPcap
		# Size to use when allocating the buffer that contains the libpcap errors.
		PCAP_ERRBUF_SIZE = UInt8.new(256)
		type PcapT = Void*
		alias X__UInt = LibC::UInt
    alias UInt = X__UInt
    alias BpfUInt32 = UInt
		alias X__TimeT = LibC::Long
		alias X__SusecondsT = LibC::Long
		alias X__UChar = UInt8
		alias UChar = X__UChar
		alias PcapHandler = UChar*, PcapPkthdr*, UChar* -> Void

		struct Timeval
			tv_sec  : X__TimeT
			tv_usec : X__SusecondsT
		end

		# Item in a list of interfaces.
		struct PcapIf
			next        : PcapIf*      # next interface in the list
			name        : LibC::Char*  # name to hand to pcap_open_live()
			description : LibC::Char*  # textual description of interface, or NULL
			addresses   : PcapAddr*    # here for structure, not for function
			flags       : BpfUInt32    # PCAP_IF_ interface flags
		end

		# Loose representation of an interface address. Not all that
		# useful at the moment!
		struct PcapAddr
			next      : PcapAddr*
			addr      : Void*
			netmask   : Void*
			broadaddr : Void*
			dstaddr   : Void*
		end

		struct PcapPkthdr
			ts     : Timeval
			caplen : BpfUInt32
			len    : BpfUInt32
		end

		# Find the default device on which to capture.
		# http://www.tcpdump.org/manpages/pcap_lookupdev.3pcap.html
		#fun pcap_lookupdev : LibC::Char*
		fun pcap_lookupdev(errbuf : LibC::Char* ) : LibC::Char*

		# Get a list of capture devices.
		# http://www.tcpdump.org/manpages/pcap_findalldevs.3pcap.html
		fun pcap_findalldevs(list : PcapIf**, errbuf : LibC::Char*) : LibC::Int

		# Free list of capture devices.
		# http://www.tcpdump.org/manpages/pcap_findalldevs.3pcap.html
		fun pcap_freealldevs(list : PcapIf*)

		# Open a device for capturing.
		# http://www.tcpdump.org/manpages/pcap_open_live.3pcap.html
		fun pcap_open_live(device : LibC::Char*, snaplen : LibC::Int, promisc : LibC::Int, to_ms : LibC::Int, errbuf : LibC::Char*) : PcapT

		# Close a capture device or savefile.
    # http://www.tcpdump.org/manpages/pcap_close.3pcap.html
		fun pcap_close(capture : PcapT)

    # Read the next packet.
    # http://www.tcpdump.org/manpages/pcap_next_ex.3pcap.html
    fun pcap_next_ex(capture : PcapT, header : PcapPkthdr**, data : UChar**) : LibC::Int

    # Check whether monitor mode can be set for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_can_set_rfmon.3pcap.html
		fun pcap_can_set_rfmon(capture : PcapT) : LibC::Int

    # Set monitor mode for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_rfmon.3pcap.html
    fun pcap_set_rfmon(capture : PcapT, rfmon : LibC::Int) : LibC::Int

    # Set the buffer size for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_buffer_size.3pcap.html
    fun pcap_set_buffer_size(capture : PcapT, buffer_size : LibC::Int) : LibC::Int

    # Set the link-layer header type to be used by a capture device.
    # http://www.tcpdump.org/manpages/pcap_set_datalink.3pcap.html 
    fun pcap_set_datalink(capture : PcapT, dlt : LibC::Int) : LibC::Int

    # Set immediate mode for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_immediate_mode.3pcap.html
    fun pcap_set_immediate_mode(capture : PcapT, immediate_mode : LibC::Int) : LibC::Int

    # Set promiscuous mode for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_promisc.3pcap.html 
    fun pcap_set_promisc(x0 : PcapT, promisc : LibC::Int) : LibC::Int

    # Set the snapshot length for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_snaplen.3pcap.html
    fun pcap_set_snaplen(capture : PcapT, snaplen : LibC::Int) : LibC::Int
  
    # Set the packet buffer timeout for a not-yet-activated capture handle.
    # http://www.tcpdump.org/manpages/pcap_set_timeout.3pcap.html
    fun pcap_set_timeout(capture : PcapT, timeout : LibC::Int) : LibC::Int

    # Set a BPF filter on a capture.
    # http://www.tcpdump.org/manpages/pcap_setfilter.3pcap.html
    # fun pcap_setfilter(capture : PcapT, bpf : BpfProgram*) : LibC::Int

    # Set the time stamp precision returned in captures.
    # http://www.tcpdump.org/manpages/pcap_set_tstamp_precision.3pcap.html
    fun pcap_set_tstamp_precision(capture : PcapT, tstamp_precision : LibC::Int) : LibC::Int

    # Set the time stamp type to be used by a capture device.
    # http://www.tcpdump.org/manpages/pcap_set_tstamp_type.3pcap.html
    fun pcap_set_tstamp_type(capture : PcapT, value : LibC::Int) : LibC::Int

    #enum PcapDirectionT
    #  PcapDInout = 0
    #  PcapDIn    
    #  PcapDOut   
    #end
    #
    #fun pcap_setdirection(x0 : PcapT, x1 : PcapDirectionT) : LibC::Int    

    # Set the state of non-blocking mode on a capture device.
    # http://www.tcpdump.org/manpages/pcap_setnonblock.3pcap.html
    fun pcap_setnonblock(capture : PcapT, nonblock : LibC::Int, errbuf : LibC::Char*) : LibC::Int

    # Create a live capture handle.
    # http://www.tcpdump.org/manpages/pcap_create.3pcap.html
    fun pcap_create(source : LibC::Char*, errbuf : LibC::Char*) : PcapT

    # Activate a capture handle.
    fun pcap_activate(capture : PcapT) : LibC::Int

    # Get the time stamp precision.
    fun pcap_get_tstamp_precision(capture : PcapT) : LibC::Int

    # Set immediate mode for a not-yet-activated capture handle.
    # Allows a libpcap-based program to process packets as soon as they arrive.
    fun pcap_set_immediate_mode(capture : PcapT, value : LibC::Int) : LibC::Int
  end
end
