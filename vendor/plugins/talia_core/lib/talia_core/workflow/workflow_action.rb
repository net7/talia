module TaliaCore
  
  # Workflow Action.
  # Each new action must be child of this class.
  class WorkflowAction

    # return Array of all roles allowed
    def self.allowed_roles
      @allowed_roles
    end

    # execute action.
    # * user: user.
    # * options: arguments. Default value is nil
    def execute(user, options = nil)
      
    end
    
  
    protected
    
    # set roles required
    def self.require_role(roles)
      @allowed_roles = roles
    end 
    
    ## check user authorization
    def authorized?(user)
      # check authorization for each role specified
      self.class.allowed_roles.each { |role|
        # return false if user is not authorized
        return false unless user.authorized_as?(role)
      }
      # return true if user is authorized
      return true
    end
    
  end

end