# Loader file for the talia command line tool
$: << File.join(File.expand_path(File.dirname(__FILE__)), "talia_cl")

# Modules
require "standalone_generator"
require "command_line"
require "talia_util"

include TaliaUtil
include TaliaCl

def run_command_line
  flags = TaliaCommands::flags
  
  if(flags.create?)
    directory = flags.talia_root? ? flags.talia_root : "talia_app"
    title
    create_standalone(directory) 
  else
    title
    puts "Use: talia <command> flags. Use talia -h to get more help."
  end
end