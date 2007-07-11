# TaliaCore loader

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

$:.unshift(File.dirname(__FILE__) + "/../../simpleassert/lib")
$:.unshift(File.dirname(__FILE__) + "/../../semantic_naming/lib") 
require 'simpleassert'
require 'semantic_naming'


# Load local things
require 'talia_core/errors'
require 'talia_core/configuration'
require 'talia_core/local_store/source_record'
require 'talia_core/source'