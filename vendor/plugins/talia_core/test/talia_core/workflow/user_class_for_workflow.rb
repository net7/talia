class User
  
  attr_accessor :roles
  
  def initialize
    @roles = ['reviewer','admin', 'editor'].sort!
  end
  
  def authorized_as?(role_name)
    if @roles.include?(role_name.to_s)
      return true
    else
      return false
    end
  end
  
end

class UserWithoutAuthorization
  
  attr_accessor :roles
  
  def initialize
    @roles = []
  end
  
  def authorized_as?(role_name)
    if @roles.include?(role_name.to_s)
      return true
    else
      return false
    end
  end
  
end
