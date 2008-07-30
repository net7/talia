require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  
  # Test class for cloning
  class CloneTest < ExpressionCard
    clone_properties N::RDF.clone_me, N::RDF.clone_me_too, N::RDF.clone_more_too
    clone_inv_properties N::RDF.clone_me_inverted
  end
  
  class ExpressionCardTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_siglum
      src = ExpressionCard.new('http://expression_card_test/test_siglum')
      src.siglum = 'foo'
      src.save!
      assert_equal(src.siglum, 'foo')
    end
    
    def test_concordance
      src1 = ExpressionCard.new('http://expression_card_test/test_concordance1')
      src2 = ExpressionCard.new('http://expression_card_test/test_concordance2')
      src1.make_concordant(src2)
      src1.save!
      src2.save!
      assert_property(src1.concordance.concordant_cards, src1, src2)
      assert_equal(src1.concordance, src2.concordance)
    end
    
    def test_clone
      src = CloneTest.new('http://expression_card_test/test_clone')
      src_rel = ExpressionCard.new('http://expression_card_test/test_clone_rel')
      src.rdf::clone_me << ['foo', 'bar']
      src.rdf::clone_me_too << src_rel
      src_rel.rdf::clone_me_inverted << src
      src.rdf::no_clone << 'none'
      src.save!
      clone = src.clone('http://expression_card_test/test_clone/the_clone')
      clone.save!
      assert_property(clone.rdf::clone_me, 'foo', 'bar')
      assert_property(clone.rdf::clone_me_too, src_rel)
      assert_property(src_rel.rdf::clone_me_inverted, src, clone)
      assert_property(clone.rdf::no_clone)
    end
    
    def test_clone_concordant
      src = ExpressionCard.new('http://expression_card_test/test_clone_concordant')
      src.save!
      clone = src.clone_concordant('http://expression_card_test/test_clone_concordant/conc')
      clone.save!
      assert_property(src.concordance.concordant_cards, src, clone)
    end
    
    def test_catalog
      src = ExpressionCard.new('http://expression_card_test/test_catalog')
      cat = Catalog.new('http://expression_card_test/test_catalog/cat')
      src.catalog = cat
      src.save!
      assert_equal(src.catalog, cat)
    end
    
    def test_manifestation
      card = make_card('test_manifestation')
      man = Manifestation.new('manifest-of-test_manifestation')
      card.add_manifestation(man)
      man.save!
      card.save!
      assert_equal(1, card.manifestations.size)
      assert_equal(man, card.manifestations[0])
    end
    
  end
end