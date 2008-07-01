# TaliaCore loader
require File.dirname(__FILE__) + '/loader_helper'

# adding talia_core subdirectory to the ruby loadpath  
file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
this_dir = File.dirname(File.expand_path(file))
$: << this_dir
$: << this_dir + '/talia_core/'

# Stuff we may need to load from sources/uninstalled versions
TLoad::require_module("activerecord", "active_record", "/../../../rails/activerecord") unless(defined?(ActiveRecord))
TLoad::require_module("activesupport", "active_support", "/../../../rails/activesupport") unless(defined?(ActiveSupport))
TLoad::require_module("assit", "assit", "/../../assit") unless(defined?(assit))
TLoad::require_module("semantic_naming", "semantic_naming", "/../../semantic_naming")
TLoad::require_module("activerdf", "active_rdf", "/../../ActiveRDF")

# Stuff we just load from the gems
gem "builder"
require "builder"

# Load local things
require 'talia_core/errors'
require 'talia_core/source'
require 'talia_core/rails_ext'
require 'talia_core/initializer'
require 'talia_core/macrocontribution'