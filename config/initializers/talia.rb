TaliaCore::Initializer.environment = ENV['RAILS_ENV']
TaliaCore::Initializer.run("talia_core")

TaliaCore::SITE_NAME = 'DiscoverySource'

# Load all the internal model classes so that subclass-aware ActiveRecord
# operations don't run into problems
model_dir = File.join(RAILS_ROOT, 'app', 'models', 'talia_core')
Dir.foreach(model_dir) do |file|
  # Use the standard loader mechanism to avoid double-loading
  require_or_load "talia_core/#{File.basename(file, '.rb')}" if(File.extname(file) == '.rb')
end

TaliaCore::FacsimileEdition::EDITION_PREFIX = 'facsimile_editions'
TaliaCore::CriticalEdition::EDITION_PREFIX = 'critical_editions'
