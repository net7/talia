require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')


module TaliaCore
  module DataTypes
    class WorkflowTest < Test::Unit::TestCase
        
      def test_no_initial_value_raises_exception
        assert_raise(TaliaCore::Workflow::NoInitialState) {
          Workflow::Base.workflow_machine({})
        }
      end
      
    end
  end
end