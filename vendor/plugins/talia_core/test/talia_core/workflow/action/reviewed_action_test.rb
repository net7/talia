require 'test/unit'
require 'workflow/action/reviewed_action'

module TaliaCore

  class ReviewedActionTest < Test::Unit::TestCase
  
    def test_roles
      # check set and get roles
      assert_equal(["reviewers"], ReviewedAction.allowed_roles)
    end
  
  end
  
end
