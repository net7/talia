ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  include AuthenticatedTestHelper
  include RoleRequirementTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all

  # Assert the given condition is false.
  def assert_not(condition, message = nil)
    assert !condition, message
  end
  alias_method :assert_false, :assert_not

  # Assert the given enumerable is empty.
  def assert_empty(enumerable, message = nil)
    assert enumerable.empty?, message
  end
  
  # Assert the current response is served with the given layout.
  def assert_layout(actual, message = nil)
    expected = @response.layout.gsub(/layouts\//, '') if @response.layout
    assert_equal expected.to_s, actual.to_s, message
  end
end

def uses_mocha(description)
  require 'rubygems'
  require 'mocha'
  yield
rescue LoadError
  $stderr.puts "Skipping #{description} tests. `gem install mocha` and try again."
end
