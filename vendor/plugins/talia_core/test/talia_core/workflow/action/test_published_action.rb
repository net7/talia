require 'test/unit'
require 'workflow/action/published_action'

module TaliaCore

  class PublishedActionTest < Test::Unit::TestCase
  
    def test_roles
      # check set and get roles
      assert_equal(["workflow_normal_users"], PublishedAction.allowed_roles)
    end
  
  end
  
end

