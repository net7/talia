require 'test/unit'
require 'talia_core/local_store/workflow/workflow_record'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', '..', 'test_helper')


module TaliaCore
  
  class WorkflowRecordTest < Test::Unit::TestCase
  
    def test_initial_state_value
      assert_raise(NoMethodError) {TaliaCore::WorkflowRecord.initial_state}
    end
      
    def test_column_was_set
      assert_raise(NoMethodError) {TaliaCore::WorkflowRecord.state_column}
    end
    
  end

end