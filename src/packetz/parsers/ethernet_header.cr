# Ethernet Header parser for a packet.
# 
# ```
# packet = Bytes[255, 255, 255, 255, 255, 255, 92, 224, 197, 122, 16, 52, 8, 6, 0, 1, 8, 0, 6, 4, 0, 1, 92, 224, 197, 122, 16, 52, 192, 168, 81, 132, 0, 0, 0, 0, 0, 0, 192, 168, 86, 25]
# eth = EthernetHeader.new(packet)
# eth.destination
# eth.source
# eth.type
# eth.payload
# ```
#
struct EthernetHeader
  property destination : String
  property source      : String
  property type        : UInt16
  property payload     : Slice(UInt8)
   
  def initialize(packet : Slice(UInt8))
     @destination = packet[0,6].map { |uint16| "%02x" % uint16 }.join(":")
     @source      = packet[6,6].map { |uint16| "%02x" % uint16 }.join(":") 
     @type        = LibC.ntohs(packet[12]) + packet[13]
     @payload     = packet[14,packet.size-14] # maybe messed this up tbh
  end
end
