require 'active_record'
require File.join('talia_core', 'workflow')


module TaliaCore
  
  # Workflow Record class.
  class WorkflowRecord < ActiveRecord::Base
    
    include TaliaCore::Workflow
    
  end

end