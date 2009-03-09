ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'talia_util/test_helpers'

module I18n
  mattr_writer :configuration, :locales
end

class Test::Unit::TestCase
  include AuthenticatedTestHelper
  include RoleRequirementTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all

  def self.with_cache
    ActionController::Base.perform_caching = true
    yield
    FileUtils.rm_rf(RAILS_ROOT + '/tmp/cache/localhost:3000')
  ensure
    ActionController::Base.perform_caching = false
  end

  # Add more helper methods to be used by all tests here...
  # Assert the current response is served with the given layout.
  def assert_layout(actual, message = nil)
    expected = @response.layout.gsub(/layouts\//, '') if @response.layout
    assert_equal expected.to_s, actual.to_s, message
  end

  # Assert the given message is displayed by flash.now
  # When using flash.now[:blah] the flash will usually be directly rendered
  # in your view, after which rails clears the flash.now flashes.
  # This means you can’t test them in your functional controller tests by going (say)
  # 
  # http://wiki.rubyonrails.org/rails/pages/HowToTestFlash.Now
  def assert_flash(status, message)
    assert_select "#flash_#{status}", message
  end

  # Assert the given message is displayed by flash.now[:error]
  def assert_flash_error(message)
    assert_flash :error, message
  end

  # Assert the given message is displayed by flash.now[:notice]
  def assert_flash_notice(message)
    assert_flash :notice, message
  end

  private
    def i18n_setup
      I18n.configuration = File.join(RAILS_ROOT, 'test', 'fixtures', 'locales')
      I18n.locales = nil
    end
    
    def i18n_teardown
      File.atomic_write(I18n.configuration, "./") do |file|
        file.write({:english => 'en-GB'}.to_yaml)
      end
    end
end

def uses_mocha(description)
  require 'rubygems'
  require 'mocha'
  yield
rescue LoadError
  $stderr.puts "Skipping #{description} tests. `gem install mocha` and try again."
end

require File.expand_path(File.dirname(__FILE__) + "/../lib/authenticated_test_helper")
include AuthenticatedTestHelper

# Set the data location for Talia
TaliaCore::CONFIG["data_directory_location"] = File.join(File.expand_path(File.dirname(__FILE__)), 'talia_test_data' )
