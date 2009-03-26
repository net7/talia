# TaliaCore loader
require File.dirname(__FILE__) + '/loader_helper'

# This is also needed for local loading
RAILS_GEM_VERSION = '2.0.5' unless defined? RAILS_GEM_VERSION

# Stuff we may need to load from sources/uninstalled versions
TLoad::require_module("assit", "assit", "/../../assit") unless(defined?(assit))
TLoad::require_module("semantic_naming", "semantic_naming", "/../../semantic_naming")
TLoad::require_module("activerdf", "active_rdf", "/../../ActiveRDF")

require 'version'