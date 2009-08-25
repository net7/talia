# Rake tasks to build the main Talia gem and other releaseables
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')
require 'rake/gempackagetask'
require 'talia_util'

namespace :talia do

  # Gem spec for the Talia gem
  talia_spec = Gem::Specification.new do |spec|
    spec.name = "talia"
    spec.summary = "Talia Digital Library - Rails application."
    spec.description = "Talia is a digital library system, developed for the Discovery project. This package contains the Talia web application."
    spec.homepage = "http://www.talia.discovery-project.eu"
    spec.author = "Talia Development Team"
    spec.email = "hahn@netseven.it"
    spec.homepage = "http://talia.discovery-project.eu/"
    spec.required_ruby_version = '>= 1.8.6'
    spec.date = Time.now
    spec.version = TaliaCore::Version::STRING
    spec.platform = Gem::Platform::RUBY

    spec.add_dependency('talia-core', ">= #{TaliaCore::Version::STRING}")
    spec.add_dependency('rails', '>= 2.0.1')
    spec.add_dependency('paginator', '>= 1.1.0')

    # Files
    files = FileList['app/**/*', 'db/migrate/*', 'lib/**/*', 'ontologies/**/*', 'public/**/*',
      'config/**/*', 'script/**/*', 'test/**/*', 'xslt/**/*']
    # Removed excludes, excruciatingly slow in JRuby 1.3.1 for some reason
    #files.exclude('**/nbproject')
    #files.exclude('**/tmp')
    files.exclude('config/database.yml')
    files.exclude('config/rdfstore.yml')
    files.exclude('config/talia_core.yml')
    #files.exclude('**/pkg')
    #files.exclude('**/*.tmp')
    spec.files = files.to_a

    spec.require_path = "lib"
    spec.test_files = FileList["{test}/**/*test.rb"].to_a
  end

  # Rake tasks
  Rake::GemPackageTask.new(talia_spec) do |pkg|
    pkg.need_tar = true
    pkg.need_zip = true
  end

end