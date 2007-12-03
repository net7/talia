require 'rubygems'
gem 'optiflag'
require 'optiflag'

# Parse for the command line
module TaliaCommands extend OptiFlagSet
  
  keyword "create" do
    description "Create a standalone Talia directory"
  end
  
  optional_flag "talia_root" do
    description "Path to the TALIA_ROOT. (default: automatic)"
    one_arg
  end
  
  and_process!
end
