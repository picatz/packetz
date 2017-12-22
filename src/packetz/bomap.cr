# Byte order mapping LibC taken from 
# https://github.com/maiha/pcap.cr/blob/967e440a2bf537a2cafa5c44f9fa031180d4aa80/src/bomap.cr
lib LibC
  fun ntohl(netlong : UInt32T) : UInt32T
  fun ntohs(netshort : UInt16T) : UInt16T
end
