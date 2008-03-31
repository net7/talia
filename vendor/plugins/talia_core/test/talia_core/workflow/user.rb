# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class User
  
  attr_accessor :roles
  
  def initialize
    @roles = ['reviewers', 'publishers'].sort!
  end
  
  def authorized_as?(role_name)
    if @roles.include?(role_name)
      return true
    else
      return false
    end
  end
  
end
