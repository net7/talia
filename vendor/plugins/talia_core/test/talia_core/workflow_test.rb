require 'test/unit'
require 'talia_core/workflow'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')


module TaliaCore
  
  class WorkflowTest < Test::Unit::TestCase
        
    def test_no_initial_value_raises_exception
      assert_raise(TaliaCore::Workflow::NoInitialState) {
        WorkflowRecord.workflow_machine({})
      }
    end
  
  end

end