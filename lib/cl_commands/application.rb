#!/usr/bin/env ruby

# This is the command line code to generate a complete Talia/Rails application
# Much of this was inspired/stolen from the way the generator for Radiant
# works.

# This will use the 'talia' generator that is defined in the Rails application.
# Define the command for the Talia console
module TaliaCommandLine
  
  desc "Create a new Talia application"
  command(:application) do
    require File.join(File.dirname(__FILE__), '..', '..', 'config', 'boot')

    app_path = ARGV.first

    require 'lib/rails_generator'
    require 'rails_generator/scripts/generate'

    class Rails::Generator::Base

      def self.use_application_sources!
        reset_sources
        sources << Rails::Generator::PathSource.new(:builtin, "#{File.dirname(__FILE__)}/../../lib/generators")
      end

    end

    Rails::Generator::Base.use_application_sources!
    Rails::Generator::Scripts::Generate.new.run(ARGV, :generator => 'talia')
  end
end

