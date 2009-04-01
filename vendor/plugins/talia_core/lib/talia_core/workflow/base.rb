require File.join('talia_core', 'workflow')

module TaliaCore
  module Workflow
    # Workflow Record class.
    class Base < ActiveRecord::Base
    
      set_table_name 'workflows'
      belongs_to :source
    
      include TaliaCore::Workflow
    
    end
  end
end