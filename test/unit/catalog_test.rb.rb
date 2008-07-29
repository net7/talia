require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class CatalogTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create
      cat = make_catalog('can_create')
      assert(Catalog.exists?(cat.uri))
    end
    
    def test_add_card
      cat = make_catalog('can_add_card')
      card = make_card('test_add_card-card')
      cat.add_card(card)
      assert_equal(1, cat.elements.size)
      assert_equal(cat.elements[0], card)
    end
    
    def test_add_with_children
      cat = make_catalog('test_add_with_children')
      make_some_cards
      cat.add_card(@cards[:parent], true)
      assert_equal(3, cat.elements.size)
    end
    
    def test_add_concordant
      cat = make_catalog('test_add_concordant')
      card = make_card('test_add_concordant-card')
      card.siglum = 'NCC-1701'
      clone = cat.add_from_concordant(card)
      clone.save!
      assert_equal("#{cat.uri}/#{card.siglum}", clone.uri.to_s)
      assert_equal(2, card.concordant_cards.size)
      assert_property(card.concordant_cards, card, clone)
    end
    
    def test_add_concordant_with_children
      cat = make_catalog('test_concordant_with_children')
      make_some_cards
      cat.add_from_concordant(@cards[:parent], true)
      assert_equal(3, cat.elements.size)
      cat.elements.each { |el| assert(el.uri.to_s =~ Regexp.new("^#{cat.uri}"), "Wrong: #{el.uri}")}
    end
    
    protected
    
    def make_some_cards
      @cards ||= {}
      @cards[:parent] = ExpressionCard.new('http://catalog_test/parent_card')
      @cards[:child_a] = ExpressionCard.new('http://catalog_test/child_a')
      @cards[:child_b] = ExpressionCard.new('http://catalog_test/child_b')
      @cards[:child_a].hyper::is_part_of << @cards[:parent]
      @cards[:child_b].hyper::is_part_of << @cards[:parent]
      @cards.each_value { |v| v.save! }
    end
    
    def make_catalog(name)
      cat = Catalog.new("http://catalog_test/#{name}")
      cat.save!
      cat
    end
    
  end
end
