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
    
    def test_concordance_from_catalog
      src = make_card('concordance_from_catalog')
      cat = make_catalog('test_for_concordance')
      clone = src.clone_concordant(src.uri + 'concord_from_catalog')
      clone.catalog = cat
      assert(0, src.concordant_cards(Catalog.default_catalog).size)
      assert(1, src.concordant_cards(cat))
    end
    
    def test_clone_default
      src = make_card('clone_default')
      src.types << N::RDF.mytype_test
      src.hyper::type << N::HYPER.mytype_test.to_s
      src.hyper::subtype << N::HYPER.my_subtype_test.to_s
      src.save!
      clone = src.clone('http://expression_card_test/test_clone_default')
      clone.save!
      assert_property(clone.hyper::type, N::HYPER.mytype_test.to_s)
      assert_property(clone.hyper::subtype, N::HYPER.my_subtype_test.to_s)
      assert(clone.types.include?(N::RDF.mytype_test))
    end
    
    def test_clone
      src = CloneTest.new('http://expression_card_test/test_clone')
      src_rel = ExpressionCard.new('http://expression_card_test/test_clone_rel')
      src.rdf::clone_me << ['foo', 'bar']
      src.rdf::clone_me_too << src_rel
      src_rel.rdf::clone_me_inverted << src
      src.rdf::no_clone << 'none'
      src.save!
      src_rel.reset!
      
      clone = src.clone('http://expression_card_test/test_clone/the_clone')
      clone.save!
      assert_property(clone.rdf::clone_me, 'foo', 'bar')
      assert_equal(clone.my_rdf[N::RDF.clone_me], ['foo', 'bar'])
      assert_property(clone.rdf::clone_me_too, src_rel)

      assert_property(src_rel.rdf::clone_me_inverted, src, clone)
      assert_property(clone.rdf::no_clone)
    end
    
    def test_clone_concordant
      src = make_card('clone_concordant')
      clone = src.clone_concordant('http://expression_card_test/test_clone_concordant/conc')
      clone.save!
      assert_property(src.concordance.concordant_cards, src, clone)
    end
    
    def test_clone_concordant_multi
      src = make_card('clone_concordant')
      clone = src.clone_concordant('http://expression_card_test/test_clone_concordant/conc')
      clone.save!
      clone2 = src.clone_concordant('http://expression_card_test/test_clone_concordant/conc2')
      clone2.save!
      assert_equal(src.concordance, clone.concordance)
      assert_equal(clone2.concordance, clone.concordance)
      assert_equal(3, src.concordance[N::HYPER.concordant_to].size)
      # The RDF update caused problems...
      assert_equal(3, src.concordance.my_rdf[N::HYPER.concordant_to].size)
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


    def test_manifestation_with_type
      card = make_card('test_manifestation_with_type')
      man = TextReconstruction.new('typed_manifestation')
      card.add_manifestation(man)
      man.save!
      card.save!
      manifs = card.manifestations(TaliaCore::TextReconstruction)
      assert_equal(1, manifs.size)
      assert_equal(man, manifs.first)
    end

    def test_default_catalog
      card = make_card('test_default_catalog')
      assert_equal(card.catalog, Catalog.default_catalog)
    end
    
    def test_material_description
      card = make_card('test_material_description')
      card.material_description = 'describe_me'
      card.save!
      assert_equal('describe_me', card.material_description)
    end
    
    def test_keywords
      card = make_card('test_keywords')
      keyw_strs = (1..3).collect { |n| "exp_test_keyword_#{n}" }
      keywords = keyw_strs.collect { |str| TaliaCore::Keyword.get_with_key_value!(str) }
      card.keywords << keywords
      card.save!
      card_n = TaliaCore::ExpressionCard.find(card.id)
      assert_equal(card_n.keywords.values, keywords)
      assert_equal(card_n.keywords_as_strings, keyw_strs)
    end
    
    def test_add_keyword
      card = make_card('test_add_keyword')
      card.add_keyword('exp_test_keyword_add')
      card.save!
      assert_equal(card.keywords_as_strings, [ 'exp_test_keyword_add' ])
    end
    
  end
end