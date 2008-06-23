require 'active_record'
require File.join('talia_core', 'workflow')

module TaliaCore
  
  # Workflow Record class.
  class WorkflowRecord < ActiveRecord::Base
    
    belongs_to :source_record
    
    include TaliaCore::Workflow
    
  end

end

# Require all workflow classes from this directory
Dir[File.join(File.dirname(__FILE__), '*.rb')].each do |f| 
  require File.join('talia_core', 'local_store', 'workflow', File.basename(f, '.rb'))
end