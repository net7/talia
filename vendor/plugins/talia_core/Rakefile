# This file is only for the tasks that are used only for "standalone" mode, and
# for development. All other tasks go to "tasks/", and are available both 
# in Rails and in standalone mode.

require 'fileutils'
require 'rake/gempackagetask'

$: << File.join(File.dirname(__FILE__))

# Load the "public" tasks
load 'tasks/talia_core_tasks.rake'
require 'version'

desc "Load fixtures into the current database.  Load specific fixtures using FIXTURES=x,y"  
task :fixtures => "talia_core:talia_init" do
  load_fixtures 
end  

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
task :migrate => "talia_core:talia_init" do
  do_migrations 
  puts "Migrations done."
end  


# DEVELOPMENT TASKS

# Describes the Talia requirements. This is only user information
def create_requirements(gemspec)
  gemspec.requirements << "rdflib (Redland RDF) + Ruby bindings (for Redland store)"
end

# Describes the Talia core dependencies on the given gem spec.
# There may be additional dependencies for each gem
def create_deps(gemspec)
  gemspec.add_dependency('builder', '>= 2.1.2')
  gemspec.add_dependency('optiflag', '>= 0.6.5')
  gemspec.add_dependency('progressbar', '>= 0.0.3')
  gemspec.add_dependency('rake', '>= 0.7.1')
  )
end

# Adds the things that are common for all gems
def create_common_gemspec(gemspec)
  gemspec.author = "Talia Development Team"
  gemspec.email = "hahn@netseven.it"
  gemspec.homepage = "http://talia.discovery-project.eu/"
  gemspec.required_ruby_version = '>= 1.8.6'
  gemspec.date = Time.now
  create_requirements(gemspec)
  create_deps(gemspec)
end

# Gem spec for the developer gem
developer_spec = Gem::Specification.new do |spec|
  spec.name = "talia-dev"
  spec.summary = "Set up the development dependencies for talia."
  spec.version = TaliaCore::Version::STRING
  spec.author = "Talia dev team"
  spec.platform = Gem::Platform::RUBY
  
  create_common_gemspec(spec)

  # Additional requirements for development
  spec.add_dependency('meta_project', '>= 0.4.15')
  spec.requirements << "Talia source code from http://talia.discovery-project.eu/svn/talia/repository/..."
  
  # Install the console
  spec.executables << 'talia_console'
end

# Rake tasks
Rake::GemPackageTask.new(developer_spec) do |pkg|
  pkg.need_tar = true
end

# Gem spec for the standard talia gem
talia_spec = Gem::Specification.new do |spec|
  spec.name = "talia-core"
  spec.summary = "Talia Digital Library. Core components."
  spec.description = "Talia is a digital library system, developed for the Discovery project. This package contains the core API for accessing a Talia database. It's completely independent from Rails."
  spec.version = TaliaCore::Version::STRING
  spec.platform = Gem::Platform::RUBY
  
  create_common_gemspec(spec)
  
  # Install the console
  spec.executables << 'talia_console'
  
  # Additional dependencies
  spec.requirements << "Install additional gems for activerdf adapters."
  spec.add_dependency('activerecord', '>= 1.99.1')
  spec.add_dependency('activesupport', '>= 1.99.1')
  spec.add_dependency('activerdf', '>= 1.7.0')
  spec.add_dependency('simpleassert', '>= 0.0.1')
  spec.add_dependency('semantic_naming', '>= 0.0.1')
  
  # Files
  spec.files = FileList["{lib}/**/*"].to_a
  spec.require_path = "lib"
  spec.test_files = FileList["{test}/**/*test.rb"].to_a
end

# Rake tasks
Rake::GemPackageTask.new(talia_spec) do |pkg|
  pkg.need_tar = true
end

desc 'Default: run unit tests.'
task :default => 'cruise'

task :cruise => ['local_migrations', 'talia_core:test', 'talia_core:rdoc']
