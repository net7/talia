# TaliaCore loader

# If true, we add the local directories to the load path
LOCAL_DEPENDENCIES = true

# adding talia_core subdirectory to the ruby loadpath  
file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
this_dir = File.dirname(File.expand_path(file))
$: << this_dir
$: << this_dir + '/talia_core/'

unless defined?(ActiveSupport)
  begin
    require 'active_support'  
  rescue LoadError
    require 'rubygems'
    gem 'activesupport'
  end
end

if(LOCAL_DEPENDENCIES)
  $:.unshift(File.dirname(__FILE__) + "/../../simpleassert/lib")
  $:.unshift(File.dirname(__FILE__) + "/../../semantic_naming/lib") 
  $:.unshift(File.dirname(__FILE__) + "/../../ActiveRDF/lib")
  # Add a loadpath for each of ActiveRDFs adapter directories
  adapters = Dir.glob(File.join(File.dirname(__FILE__), '/../../ActiveRDF', 'activerdf-*'))
  adapters.each do |adapter|
    $:.unshift(adapter + "/lib")
  end
end

require 'simpleassert'
require 'semantic_naming'

# Load local things
require 'talia_core/errors'
require 'talia_core/source'
require 'talia_core/initializer'