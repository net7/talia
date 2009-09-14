
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the ActiveSource
  class SourceReaderTest < Test::Unit::TestCase

    suppress_fixtures
    
    def setup
      @test_xml = "<sources><source><attribute><predicate>uri\n</predicate>\n<value>http://foodonga.com</value></attribute><attribute><predicate>http://bongobongo.com</predicate><value>foo\n</value><value> bar</value><object>http:/bingobongo.com</object></attribute></source></sources>"
      @sources = ActiveSourceParts::Xml::SourceReader.sources_from(@test_xml)
    end
    
    def test_sources
      assert_equal(1, @sources.size)
    end
    
    def test_attributes
      assert_kind_of(Hash, @sources.first)
    end
    
    def test_uri
      assert_equal('http://foodonga.com', @sources.first['uri'])
    end
    
    def test_predicate
      assert_equal(['foo', 'bar', '<http:/bingobongo.com>'], @sources.first['http://bongobongo.com'])
    end
    
  end
end