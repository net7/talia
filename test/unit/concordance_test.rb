require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class ConcordanceTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    suppress_fixtures
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create
      concord = make_concord('test_can_create')
      assert(Source.exists?(concord.uri))
    end
    
    def test_can_add
      concord = make_concord('test_can_add', false)
      card1 = make_card('test_can_add_card1', false)
      card2 = make_card('test_can_add_card2', false)
      concord.add_card(card1)
      concord.add_card(card2)
      concord.save!
      card1.save!
      card2.save!
      assert_equal(2, concord.concordant_cards.size)
      assert_equal(concord, card1.concordance)
      assert_equal(concord, card2.concordance)
    end
    
    def test_merge
      concord1 = make_concord('test_merge_1')
      concord2 = make_concord('test_merge_2')
      card1 = make_card('test_merge_card1')
      card2 = make_card('test_merge_card2')
      concord1.add_card(card1)
      concord2.add_card(card2)
      concord1.merge(concord2)
      concord1.save!
      assert_equal(2, concord1.concordant_cards.size)
      assert(!Concordance.exists?(concord2.id))
    end
    
    def test_concord_from_catalog
      concord = make_concord('test_from_catalog')
      card1 = make_card('test_from_cat1_card')
      card2 = make_card('test_from_cat2_card')
      cat = make_catalog('catalog_for_test')
      card2.catalog = cat
      card2.save!
      concord.add_card(card1)
      concord.add_card(card2)
      concord.save!
      assert_equal(2, concord.concordant_cards.size)
      assert_equal(1, concord.concordant_cards(cat.uri).size)
      assert_equal(1, concord.concordant_cards(Catalog.default_catalog).size)
      assert_equal(card2, concord.concordant_cards(cat)[0])
    end
    
    
    protected
    
    def make_concord(name, save = true)
      concord = Concordance.new("http://concordance_test/#{name}")
      concord.save! if(save)
      concord
    end
  end
end