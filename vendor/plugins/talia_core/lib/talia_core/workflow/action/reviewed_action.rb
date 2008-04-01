require 'workflow/workflow_action'

module TaliaCore
  
  class ReviewedAction < WorkflowAction
    
    # role required
    require_role ["reviewers"]
    
    def initialize
      
    end
    
    # execute action.
    # * user: user.
    # * options: arguments. Default value is nil
    def execute(user, options = nil)
      # check user authorization
      raise "User is not authorized for execute this action" unless authorized?(user)
    end
    
  end

end