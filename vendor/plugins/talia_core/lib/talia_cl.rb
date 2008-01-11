# This is the loader file for the Talia command line tool.
# 
# The Talia command line works as follows: This file will load some helper
# methods that can be used to register subcommands for the command line tool.
#
# Each subcommand is registered with a name (as symbol), a description string
# and a block that will be run if the command is selected.
#
# If the command line processing is started, the first command line argument 
# will be taken as the name of the command to be run. The argument will be
# removed from ARGV, and then the block belonging to the command will be 
# executed.
$: << File.join(File.expand_path(File.dirname(__FILE__)), "talia_cl")

# require basic stuff
require "talia_core"
require "talia_util"

include TaliaUtil

require 'command_line'
require 'core_commands'

# Quick and dirty: Try to load the (Rails) add-on commands. If not found, ignore.
begin
  require 'addon_commands'
  puts "Additional talia commands loaded"
rescue LoadError
  puts "No additional talia commands found or loaded."
end


# Runs the command line
def run_command_line
  Util::title
  
  command = ARGV.shift
  
  if(TaliaCommandLine::command?(command))
    TaliaCommandLine::run_command(command)
  else
    puts "Use talia <command> - possible commands:"
    TaliaCommandLine::each do |command, description| 
      puts "#{command}\t- #{description}"
    end
  end
end