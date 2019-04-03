# -*- coding: binary -*-

require 'rex/post/meterpreter/extensions/malleable/tlv'

module Rex
module Post
module Meterpreter
module Extensions
module Malleable

###
#
# MALLEABLE Server functionality
#
###
class Malleable < Extension

  def initialize(client)
    super(client, 'malleable')

    client.register_extension_aliases(
      [
        {
          'name' => 'malleable',
          'ext'  => self
        },
      ])
  end

  def testCommand()
    request = Packet.create_request('malleable_test_command')
    response = client.send_request(request)
    {
      :responseString => response.get_tlv_value(TLV_TYPE_MALLEABLE_INTERFACES),
    }
  end

  def setScript()
    request = Packet.create_request('malleable_set_script')
    request.add_tlv(TLV_TYPE_MALLEABLE_INTERFACES, "function encrypt(s);s = 'THIS WORKS WAY TO WELL';return s;end;")
    response = client.send_request(request)
    {
      :responseString => response.get_tlv_value(TLV_TYPE_MALLEABLE_INTERFACES),
    }
  end

end

end; end; end; end; end
