require 'test/unit'
require 'workflow/workflow_builder'

# Load the helper 
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore

  # Test Workflow classes
  class WorkflowTest < Test::Unit::TestCase
    
    # Establish the database connection for the test
    TestHelper.startup
     
    def setup
      TestHelper.fixtures
      @workflow_dsl_file = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'Workflow', 'temp1.rb'))
      @workflow_xml_file = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'Workflow', 'temp2.xml'))
      @workflow_xml_multi_file = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'Workflow', 'temp3.xml'))
    end

    def test_workflow_builder
      
      # build workflow from code
      workflow1 = TaliaCore::WorkflowBuilder.workflow do
        TaliaCore::WorkflowBuilder.step "submitted", "review",   "reviewed"
        TaliaCore::WorkflowBuilder.step "reviewed",  "vote",     "reviewed"
        TaliaCore::WorkflowBuilder.step "reviewed",  "publish",  "published"
        TaliaCore::WorkflowBuilder.step "published", "auto",     "published"
      end
      # check workflow1 class builded
      assert_equal(Workflow, workflow1.class)
      
      # build workflow from DSL
      workflow2 = WorkflowBuilder.load_dsl(1, @workflow_dsl_file)
      # check workflow2 class builded
      assert_kind_of(Workflow, workflow2)

      # build workflow from XML
      workflow3 = WorkflowBuilder.load_xml(2, @workflow_xml_file)
      # check workflow3 class builded
      assert_kind_of(Workflow, workflow3)
      
      # build workflow from XML containing some workflow
      workflow4 = WorkflowBuilder.load_xml(3, @workflow_xml_multi_file, "default")
      # check workflow4 class builded
      assert_kind_of(Workflow, workflow4)
      
    end
    
    def test_workflow
      
      # load workflow from dsl file
      workflow = WorkflowBuilder.load_dsl(2, @workflow_dsl_file)
      assert_kind_of(Workflow,workflow)
      
      # check source id
      assert_equal(2, workflow.source)
      
      # check state
      assert_equal(:submitted, workflow.state)
      
      # execute an action
      workflow.action(:review, 'my_user')
      assert_equal(:reviewed, workflow.state)
      
      # execute an action sending parameters
      workflow.action(:publish, 'my_user', {:vote => 10})
      assert_equal(:published, workflow.state)
      
    end
    
    def test_workflow_record
      
      # load workflow (retrieve data from database)
      assert WorkflowRecord.find(:first, :conditions => {:source_record_id => 1})
      workflow = WorkflowBuilder.load_dsl(1, @workflow_dsl_file)
      assert_kind_of(Workflow, workflow)
      assert_equal(:reviewed, workflow.state)

      # load workflow (create new record in database)
      WorkflowRecord.delete_all 'source_record_id = 2' 
      assert_nil WorkflowRecord.find(:first, :conditions => {:source_record_id => 2})
      workflow = WorkflowBuilder.load_xml(2, @workflow_xml_file)
      assert_kind_of(Workflow,workflow)
      assert_equal(:submitted, workflow.state)
      assert WorkflowRecord.find(:first, :conditions => {:source_record_id => 2})
      
    end
    
  end

end