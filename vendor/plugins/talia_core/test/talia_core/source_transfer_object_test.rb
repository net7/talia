require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  class SourceTransferObjectTest < Test::Unit::TestCase
    def test_with_uri
      s = SourceTransferObject.new("#{N::LOCAL}Homer_Simpson")
      assert_equal('Homer Simpson', s.titleized)
      assert_equal("#{N::LOCAL}Homer_Simpson", s.to_s)
      assert_equal("#{N::LOCAL}Homer_Simpson", s.uri.to_s)
      assert s.source?
    end
    
    def test_with_string
      s = SourceTransferObject.new('Homer Simpson')
      assert_equal('Homer Simpson', s.titleized)
      assert_equal('Homer Simpson', s.to_s)
      assert_nil(s.uri)
      assert_not s.source?
    end
  end
end
