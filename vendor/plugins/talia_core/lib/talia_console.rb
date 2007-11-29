# Loader file for the console
$: << File.join(File.expand_path(File.dirname(__FILE__)), "talia_console")

# Console modulles
require "talia_commands"
require "command_line"
