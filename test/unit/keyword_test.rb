require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class KeywordTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_create
      keyw = make_keyword('test_create')
      assert('test_create', keyw.keyword_value)
    end
    
    def test_exists_with_keyword
      make_keyword('test_exists_with_keyword')
      assert(Keyword.exists_with_keyword?('test_exists_with_keyword'))
      assert(!Keyword.exists_with_keyword?('test_exists_not_with_keyword'))
    end
    
    def test_find_by_keyword
      keyw = make_keyword('test_find_by_keyword')
      assert_equal(keyw, Keyword.find_by_keyword('test_find_by_keyword'))
    end
    
    def test_get_with_key_value
      keyw_sample = make_keyword('test_get_with_key_one')
      assert_equal(keyw_sample, Keyword.get_with_key_value!('test_get_with_key_one'))
      assert_equal('test_get_with_key_two', Keyword.get_with_key_value!('test_get_with_key_two').keyword_value)
    end
    
    def test_validate
      invalid = Keyword.new('http://testkyewords/test_validate')
      invalid.keyword_value = 'foobar'
      assert_raise(ActiveRecord::RecordInvalid) { invalid.save! }
    end
    
    def test_tagged_sources
      card = make_card('test_tagged_sources')
      kw = make_keyword('test_tagged_sources')
      card.hyper::keyword << kw
      card.save!
      assert_equal([card], kw.tagged_sources)
    end
    
    def test_tagged_sources_with_class
      kw = make_keyword('test_tagged_sources_with_class')
      card = make_card('test_tagged_sources_with_class')
      book = make_book('test_tagged_sources_with_class')
      card.hyper::keyword << kw
      book.hyper::keyword << kw
      card.save!
      book.save!
      assert_equal([book], kw.tagged_sources(TaliaCore::Book))
      assert_equal(2, kw.tagged_sources.size)
    end
    
    private
    
    def make_keyword(name)
      kw = Keyword.new(Keyword.uri_for(name))
      kw.keyword_value = name
      kw.save!
      kw
    end
    
  end
end

