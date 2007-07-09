# TaliaCore loader

# adding talia_core subdirectory to the ruby loadpath  
file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
this_dir = File.dirname(File.expand_path(file))
$: << this_dir
$: << this_dir + '/talia_core/'

# Check for active_support
unless defined?(ActiveSupport)
  begin
    $:.unshift(File.dirname(__FILE__) + "/../../activesupport/lib")  
    require 'active_support'  
  rescue LoadError
    require 'rubygems'
    gem 'activesupport'
  end
end

require 'simpleassert/simpleassert'

require 'talia_core/errors'
require 'naming/uri'
require 'naming/namespace'
require 'naming/source_class'
require 'naming/predicate'
require 'talia_core/configuration'
require 'talia_core/local_store/source_record'
# require 'talia_core/source'