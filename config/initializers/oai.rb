require 'oai'
class BookProvider < OAI::Provider::Base
    repository_name "My OAI Provider"
    repository_url 'http://localhost:3100/oaicontroller'
    record_prefix 'oai:talia'
    admin_email 'root@localhost'
    # TODO: Check for right class
    source_model OAI::Provider::ActiveRecordWrapper.new(ActiveRecord::Base)
end