require 'workflow/workflow_action'
require 'local_store/workflow_record'


module TaliaCore
  
  class ReviewedAction < WorkflowAction
    
    # role required
    require_role ["reviewers"]
    
    def initialize
      
    end
    
    # execute action.
    # * user: user.
    # * options: arguments. Default value is nil
    #
    # Vote value 
    def execute(user, options = nil)
      # check user authorization
      raise "User is not authorized for execute this action" unless authorized?(user)
      
      if (!options.nil? && !options[:vote].nil?)
        # get vote value
        vote = options[:vote]
        # get source_record_id value
        source_record_id = options[:source_record_id]

        # check if vote is included into [-5; +5] gap
        if ((vote >= -5) && (vote <= 5))
          # get current workflow record
          current_workflow = WorkflowRecord.find(:first, :conditions => {:source_record_id => source_record_id})
          # set new current vote value
          current_workflow.arguments = (current_workflow.arguments.to_i + vote).to_s
          # set result value
          options[:result] = current_workflow.arguments
          # save current workflow record
          current_workflow.save
        end
      end
      
    end
    
  end

end