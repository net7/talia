# We just capture the main object for later reuse, as a workaround for adding
# the command line commands to it.
MAIN_OBJECT = self

# Define the command for the Talia console
module TaliaCommandLine
 
  desc "Start the Talia console"
  command(:console) do
    # Loader file for the talia console
    $: << File.join(File.expand_path(File.dirname(__FILE__)), "talia_console")
    
    # Console modules
    require "talia_commands"
    require "cl_options"

    # Foreign modules
    require "irb"
    require "rake"

    puts "\nEnter <thelp> for help on the Talia-specific commands."
    puts ""

    flags = TaliaCommands::flags

    unless(flags.noinit?)
      Util::init_talia
      Util::talia_config if(flags.verbose?)
    else
      puts "Talia not initialized, as requested."
    end
    
    IRB.start
    
#    if __FILE__ == $0
#      IRB.start(__FILE__)
#    else
#      # check -e option
#      if /^-e$/ =~ $0
#        IRB.start(__FILE__)
#      else
#        IRB.setup(__FILE__)
#      end
#    end
  end

end
