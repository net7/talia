# Loader for TaliaUtil module
this_dir = File.dirname(File.expand_path(__FILE__))
$: << this_dir unless($:.include?(this_dir))

require 'version'
require 'talia_util/talia_util'
require 'talia_util/data_import'
require 'talia_util/rdf_import'
require 'talia_util/yaml_import'
require 'talia_util/hyper_xml_import'
require 'talia_util/rdf_update'