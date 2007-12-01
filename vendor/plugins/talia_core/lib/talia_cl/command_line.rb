require 'rubygems'
gem 'optiflag'
require 'optiflag'

# Parse for the command line
module TaliaCommands extend OptiFlagSet
  
  optional_flag "talia_root" do
    description "Path to the TALIA_ROOT. (default: automatic)"
    one_arg
  end
  
  and_process!
end
