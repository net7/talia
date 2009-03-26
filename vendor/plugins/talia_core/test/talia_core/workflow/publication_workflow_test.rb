require 'test/unit'

require File.join(File.dirname(__FILE__), 'user_class_for_workflow')

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')


module TaliaCore
  class PublicationWorkflowTest < Test::Unit::TestCase
    include TaliaCore::Workflow
    
    def setup
      @user = User.new
      @user_without_autorization = UserWithoutAuthorization.new
    end
    
    def test_initial_state_value
      assert_equal :submitted, TaliaCore::Workflow::PublicationWorkflow.initial_state
    end
    
    def test_column_was_set
      assert_equal 'state', TaliaCore::Workflow::PublicationWorkflow.state_column
    end
    
    def test_initial_state
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      assert_equal :submitted, record.current_state
      assert record.submitted?
    end
    
    def test_states_were_set
      [:submitted, :accepted, :rejected, :published].each do |s|
        assert TaliaCore::Workflow::PublicationWorkflow.states.include?(s)
      end
    end
    
    def test_event_methods_created
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      %w(vote! direct_publish! publish!).each do |event|
        assert record.respond_to?(event)
      end
    end
    
    def test_query_methods_created
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      %w(submitted? accepted? rejected? published?).each do |event|
        assert record.respond_to?(event)
      end
    end
      
    def test_transition_table
      tt = TaliaCore::Workflow::PublicationWorkflow.transition_table
        
      assert tt[:vote].include?(SupportingClasses::StateTransition.new(:from => :submitted, :to => :submitted))
      assert tt[:vote].include?(SupportingClasses::StateTransition.new(:from => :submitted, :to => :accepted))
      assert tt[:vote].include?(SupportingClasses::StateTransition.new(:from => :submitted, :to => :rejected))
    end
    
    def test_next_state_for_event
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      assert_equal :submitted, record.next_state_for_event(:vote)
    end
      
    def test_loopback_event
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      record.vote! @user, 1
      assert record.submitted?
    end
      
    def test_can_go_to_accepted
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      record.vote!(@user, 10)
      assert_equal :accepted, record.current_state
      assert_equal 10, record.state_properties[:vote]
    end
            
    def test_can_go_to_rejected
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      record.vote!(@user, -10)
      assert_equal :rejected, record.current_state
      assert_equal(-10, record.state_properties[:vote])
    end

    def test_ignore_invalid_events
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      # this is an invalid event for submitted state
      record.publish!(@user)
      assert_equal :submitted, record.current_state
    end
    
    def test_direct_publish_event
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      record.direct_publish!(@user)
      assert_equal :published, record.current_state
      assert_equal 0, record.state_properties[:vote]
    end
    
    def test_vote_and_publish_event
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      # go to accepted state
      record.vote! @user, 10
      assert_equal :accepted, record.current_state
       
      # go to published state
      record.publish! @user
      assert_equal :published, record.current_state
    end
    
    # Write some code for this method if you need to implement an entry and/or exit actions
    # 
    # def test_entry_and_exit_not_run_on_loopback_transition
    #          
    # end
    #
    # def test_entry_and_after_actions_called_for_initial_state
    # 
    # end
    #  
    
    def test_find_first_in_state
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      
      # move current record to publish
      record.vote! @user, 10
      record.publish! @user
      
      records_by_find_by = TaliaCore::Workflow::PublicationWorkflow.find_by_state('published')
      records_by_in_state = TaliaCore::Workflow::PublicationWorkflow.find_in_state(:first, :published)
      
      assert_equal records_by_find_by, records_by_in_state
    end
    
    def test_find_all_in_state
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      
      # move current record to publish
      record.vote! @user, 10
      record.publish! @user
      
      records_by_find_by = TaliaCore::Workflow::PublicationWorkflow.find_all_by_state('published')
      records_by_in_state = TaliaCore::Workflow::PublicationWorkflow.find_in_state(:all, :published)
      
      assert_equal records_by_find_by, records_by_in_state
    end
      
    def test_find_all_in_state_with_conditions
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 2)
      
      # find all with conditions
      records = TaliaCore::Workflow::PublicationWorkflow.find_in_state(:all, :submitted, :conditions => ['source_id > ?', '0'])
        
      assert_equal 2, records.size
      assert_equal 1, records.first.source_id
    end
      
    def test_find_first_in_state_with_conditions
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 2)
      
      # find all with conditions
      records = TaliaCore::Workflow::PublicationWorkflow.find_in_state(:first, :submitted, :conditions => ['source_id = ?', '1'])
      
              
      assert_equal 1, records.source_id
    end
      
    def test_count_in_state_with_conditions
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 2)
      
      cnt0 = TaliaCore::Workflow::PublicationWorkflow.count(:conditions => ['state = ?', 'submitted'])
      cnt  = TaliaCore::Workflow::PublicationWorkflow.count_in_state(:submitted)
        
      assert_equal cnt0, cnt
    end
      
    
    def test_find_in_invalid_state_raises_exception
      assert_raise(InvalidState) {
        TaliaCore::Workflow::PublicationWorkflow.find_in_state(:all, :invalid_state)
      }
    end
      
    def test_count_in_invalid_state_raises_exception
      assert_raise(InvalidState) {
        TaliaCore::Workflow::PublicationWorkflow.count_in_state(:invalid_state)
      }
    end

    def test_not_authorized_user_raises_exception
      # clear all records and create a new record
      TaliaCore::Workflow::PublicationWorkflow.delete_all 
      record = TaliaCore::Workflow::PublicationWorkflow.create(:source_id => 1)
      
      # call vote without user parameter
      assert_raise(ArgumentError) {
        record.vote!
      }
      
      # call vote without user parameter
      assert_raise(NoMethodError) {
        record.vote! 10
      }

      # call vote user not authorized
      assert_raise(NoAuthorizedException) {
        record.vote! @user_without_autorization, 10
      }
    end
    
    def test_attach
      src = Source.new('http://testattach.com/publication_workflow')
      src.workflow = Workflow::PublicationWorkflow.new
      src.save!
      assert_kind_of(Workflow::PublicationWorkflow, Source.find(src.id).workflow)
    end
    
  end

end