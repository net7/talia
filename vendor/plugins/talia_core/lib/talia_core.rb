# TaliaCore loader
require File.dirname(__FILE__) + '/talia_dependencies'

TLoad::force_rails_parts unless(defined?(ActiveRecord))

# Load local things
require 'talia_core/errors'
require 'talia_core/rails_ext'
require 'talia_core/initializer'
