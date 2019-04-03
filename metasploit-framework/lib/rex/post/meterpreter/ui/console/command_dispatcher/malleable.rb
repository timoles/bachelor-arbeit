# -*- coding: binary -*-
require 'rex/post/meterpreter'

module Rex
module Post
module Meterpreter
module Ui

###
#
# Malleable extension.
#
###
class Console::CommandDispatcher::Malleable

  Klass = Console::CommandDispatcher::Malleable

  include Console::CommandDispatcher

  #
  # Initializes an instance of the malleable command interaction.
  #
  def initialize(shell)
    super
  end

  #
  # List of supported commands.
  #
  def commands
    {
      "malleableTestCommand" => "Test malleable command",
      "malleableSetScript" => "Malleable set LUA script"
    }
  end

  def cmd_malleableTestCommand(*args)
    print_status("Sending test command")
    res = client.malleable.testCommand()
    print_status("Does it work? #{res[:responseString]}")
    print_status("Test command sent")
  end
  def cmd_malleableSetScript(*args)
    print_status("Sending lua script")
    res = client.malleable.setScript()
    print_status("Did script set? #{res[:responseString]}")
    print_status("LUA script setting done")
  end
  #
  # Name for this dispatcher
  #
  def name
    "Malleable extension"
  end

end

end
end
end
end
