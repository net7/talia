require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class CatalogTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers

    suppress_fixtures

    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
      setup_once(:cards) { make_some_cards }
    end
    
    def test_can_create
      cat = make_catalog('can_create')
      assert(Catalog.exists?(cat.uri))
    end
    
    def test_add_card
      cat = make_catalog('can_add_card')
      card = make_card('test_add_card-card')
      cat.add_card(card)
      card.save!
      assert_equal(1, cat.elements.size)
      assert_equal(cat.elements[0], card)
    end
    
    def test_add_with_children
      cat = make_catalog('test_add_with_children')
      cat.add_card(@cards[:parent], true)
      assert_equal(3, cat.elements.size)
    end
    
    def test_add_concordant
      cat = make_catalog('test_add_concordant')
      card = make_card('test_add_concordant-card')
      card.siglum = 'NCC-1701'
      clone = cat.add_from_concordant(card)
      assert_equal("#{cat.uri}/#{card.siglum}", clone.uri.to_s)
      assert_equal(2, card.concordant_cards.size)
      assert_property(card.concordant_cards, card, clone)
    end
    
    def test_add_concordant_with_children
      cat = make_catalog('test_concordant_with_children')
      cat.add_from_concordant(@cards[:parent], true)
      cat.save!
      assert_equal(3, cat.elements.size)
      cat.elements.each { |el| assert(el.uri.to_s =~ Regexp.new("^#{cat.uri}"), "Wrong: #{el.uri}")}
      cat.elements.each { |el| assert_equal(2, el.concordant_cards.size, "Element #{el.uri} has #{el.concordant_cards}")}
    end

    def test_multi_concordances
      cat_orig = make_catalog('test_concordant_with_children')
      cat1 = make_catalog('test_concordant_with_children_orig')
      cat2 = make_catalog('test_concordant_with_children2')
      card = make_card('test_concordant_with_children_card')
      card.catalog = cat_orig
      cat1.add_from_concordant(card)
      cat2.add_from_concordant(card)
      assert_equal(1, card.concordant_cards(cat1).size)
      assert_equal(1, card.concordant_cards(cat2).size)
      card.save!
      card_fresh = TaliaCore::ActiveSource.find(card.uri)
      assert_equal(1, card_fresh.concordant_cards(cat1).size)
      assert_equal(1, card_fresh.concordant_cards(cat2).size)
    end
    
    protected
    
    def make_some_cards
      cards = {}
      cards[:parent] = ExpressionCard.new('http://catalog_test/parent_card')
      cards[:child_a] = ExpressionCard.new('http://catalog_test/child_a')
      cards[:child_b] = ExpressionCard.new('http://catalog_test/child_b')
      cards[:child_a].dct::isPartOf << cards[:parent]
      cards[:child_b].dct::isPartOf << cards[:parent]
      cards.each_value { |v| v.save! }
      assert_equal(cards[:parent], cards[:child_a].dct::isPartOf.first)
      puts Source.find(:all, :find_through => [N::DCT.isPartOf, cards[:parent]]).size
      assert_equal(2, Source.find(:all, :find_through => [N::DCT.isPartOf, cards[:parent]]).size)
      cards
    end
    
  end
end
