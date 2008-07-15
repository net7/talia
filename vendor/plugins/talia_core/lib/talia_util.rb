# TaliaCore loader
require File.dirname(__FILE__) + '/talia_dependencies'

require 'core_ext'
require 'talia_util/talia_util'
require 'talia_util/data_import'
require 'talia_util/rdf_import'
require 'talia_util/yaml_import'
require 'talia_util/hyper_xml_import'
require 'talia_util/rdf_update'
require 'talia_util/progressbar'

# Stuff we just load from the gems
gem "builder"
require "builder"