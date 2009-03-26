require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')


module TaliaCore
  
  class WorkflowBaseTest < Test::Unit::TestCase
  
    def test_initial_state_value
      assert_raise(NoMethodError) {TaliaCore::Workflow::Base.initial_state}
    end
      
    def test_column_was_set
      assert_raise(NoMethodError) {TaliaCore::Workflow::Base.state_column}
    end
    
  end

end