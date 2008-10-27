require 'oai'
class BookProvider < OAI::Provider::Base
    repository_name "My OAI Provider"
    repository_url 'http://localhost:3100/oaicontroller'
    record_prefix 'oai:talia'
    admin_email 'oaimaste@talia.discovery-project.eu'
    # TODO: Check for right class
    source_model TaliaCore::Oai::ActiveSourceWrapper.new
end