# 
# This defines the "addon commands" for the talia command line tool. These are
# the Rails specific commands, which are only present if the Rails part of Talia
# is installed
#

command_dir = File.expand_path(File.join(File.dirname(__FILE__), 'cl_commands'))

$: << command_dir

Dir["#{command_dir}/*.rb"].each do |file|
  require File.basename(file.gsub(/\.rb$/, ''))
end
