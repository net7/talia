TaliaCore::Initializer.environment = ENV['RAILS_ENV']
TaliaCore::Initializer.run("talia_core")

TaliaCore::SITE_NAME = 'DiscoverySource'

TaliaCore::FacsimileEdition::EDITION_PREFIX = 'facsimile_editions'
TaliaCore::CriticalEdition::EDITION_PREFIX = 'critical_editions'

# Load all the internal model classes so that subclass-aware ActiveRecord
# operations don't run into problems
model_dir = File.join(RAILS_ROOT, 'app', 'models', 'talia_core')
Dir.foreach(model_dir) do |file|
  # Use the standard loader mechanism to avoid double-loading
  TaliaCore.const_get(File.basename(file, '.rb').classify) if(File.extname(file) == '.rb')
end
