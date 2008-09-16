# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  class SingularAccessorTest < ActiveSource
    singular_property :siglum, N::RDFS.siglum
  end
  
  # Test the ActiveSource
  class ActiveSourceTest < Test::Unit::TestCase
    fixtures :active_sources, :semantic_properties, :semantic_relations
    
    N::Namespace.shortcut(:as_test_preds, 'http://testvalue.org/')
    
    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_rdf
        true
      end
    end
    
    def test_exists
      assert_not_nil(ActiveSource.find(:first))
    end
    
    def test_create_existing
      src = ActiveSource.new(active_sources(:testy).uri)
      assert_equal(src, active_sources(:testy))
      assert(!src.new_record?)
    end
    
    def test_create_new
      src_uri = 'http://foobarxxx.com/imallnew'
      src = ActiveSource.new(src_uri)
      assert_equal(src_uri, src.uri)
      assert(src.new_record?)
    end
    
    def test_create_vanilla
      src = ActiveSource.new
      # Somehow this gives different results for JRuby/Ruby
      assert(src.uri == nil || src.uri == '')
      assert(src.new_record?)
    end
    
    def test_objects
      assert_equal(1, active_sources(:testy).objects.size)
      assert_equal(4, active_sources(:multirel).objects.size)
    end
    
    def test_content
      assert_kind_of(TaliaCore::SemanticProperty, active_sources(:testy).objects[0])
    end
    
    def test_objects_finder
      assert_equal(1, active_sources(:testy).objects.find(:all).size)
    end
    
    def test_accessor
      assert_equal(3, active_sources(:multirel)['http://testvalue.org/multirel'].size)
      assert_equal(1, active_sources(:multirel)['http://testvalue.org/multi_b'].size)
    end
    
    def test_delete
      del = active_sources(:deltest)
      assert_equal(2, del['http://testvalue.org/delete_test'].size)
      del["http://testvalue.org/delete_test"].remove("Delete Me!")
      del.save!
      assert_equal(1, active_sources(:deltest)["http://testvalue.org/delete_test"].size)
    end
    
    def test_delete_relation
      del = active_sources(:deltest_rel)
      assert_equal(2, del['http://testvalue.org/delete_test'].size)
      del['http://testvalue.org/delete_test'].remove(active_sources(:deltest_rel_target1))
      del.save
      assert_equal(1, active_sources(:deltest_rel)["http://testvalue.org/delete_test"].size)
    end
    
    def test_accessor_tripledup
      assert_equal(2, active_sources(:duplicator)['http://testvalue.org/dup_rel'].size)
    end
    
    def test_accessor_tripledup_delete
      dupey = active_sources(:dup_for_delete)
      assert_equal(2, dupey['http://testvalue.org/dup_rel'].size)
      dupey['http://testvalue.org/dup_rel'].remove('The test value')
      dupey.save!
      assert_equal(1, active_sources(:dup_for_delete)['http://testvalue.org/dup_rel'].size)
      dupey['http://testvalue.org/dup_rel'].remove('The test value')
      dupey.save!
      assert_equal(0, active_sources(:dup_for_delete)['http://testvalue.org/dup_rel'].size)
    end
    
    def test_uri
      assert_equal("http://testy.com/testme/hard", active_sources(:testy).uri)
    end
    
    def test_create
      src = ActiveSource.new
      src.uri = "http://www.testy.org/create_test"
      src.save!
      assert_equal(1, ActiveSource.find(:all, :conditions => { :uri =>  "http://www.testy.org/create_test" } ).size)
    end
    
    def test_associate
      test_src = active_sources(:assoc_test)
      test_src["http://foo/assoc_test"] << active_sources(:assoc_test_target)
      test_src["http://bar/assoc_test_prop"] << semantic_properties(:testvalue)
      test_src.save!
      assert_equal(1, active_sources(:assoc_test)["http://foo/assoc_test"].size)
      assert_equal(1, active_sources(:assoc_test)["http://bar/assoc_test_prop"].size)
      assert_equal('TaliaCore::ActiveSource', SemanticRelation.find(:first, 
          :conditions => { 
            :subject_id => test_src.id, 
            :predicate_uri => 'http://foo/assoc_test',
            :object_id => active_sources(:assoc_test_target)
          }).object_type)
    end
    
    def test_create_validate
      src = ActiveSource.new
      assert_raise(ActiveRecord::RecordInvalid) { src.save! }
    end
    
    def test_create_validate_format
      src = ActiveSource.new
      src.uri = "invalid"
      assert_raise(ActiveRecord::RecordInvalid) { src.save! }
    end
    
    def test_create_validate_unique
      src = ActiveSource.new
      src.uri = active_sources(:testy).uri
      assert_raise(ActiveRecord::RecordInvalid) { src.save! }
    end
    
    def test_inverse
      assert_equal(2, active_sources(:assoc_inverse_start).inverse['http://testvalue.org/inverse_test'].size)
      second_rel = active_sources(:assoc_inverse_start).inverse['http://testvalue.org/inverse_test_rel2']
      assert_equal(1, second_rel.size)
      assert_kind_of(TaliaCore::ActiveSource, second_rel[0])
      assert_equal('http://testy.com/testme/inverse_end_c', second_rel[0].uri)
    end
    
    def test_predicate_access
      assert_equal('The test value', active_sources(:testy).predicate(:as_test_preds, :the_rel1)[0])
    end
    
    def test_predicate_assign_string
      src = active_sources(:assoc_predicate_test)
      src.predicate_set(:as_test_preds, :test, "Foo")
      src.save!
      src_chng = TaliaCore::ActiveSource.find(src.id)
      assert_equal('Foo', src_chng[N::AS_TEST_PREDS.test][0])
    end
    
    def test_predicate_assign_rel
      src = active_sources(:assoc_predicate_test)
      src.predicate_set(:as_test_preds, :test_rel, src)
      src.save!
      assert_equal(src.uri, active_sources(:assoc_predicate_test)[N::AS_TEST_PREDS.test_rel][0].uri)
    end
    
    def test_predicate_assign_uniq
      src = active_sources(:assoc_predicate_test)
      src.predicate_set(:as_test_preds, :test_uniq, "foo")
      src.predicate_set_uniq(:as_test_preds, :test_uniq, "bar")
      src.predicate_set_uniq(:as_test_preds, :test_uniq, "foo")
      assert_property(src.predicate(:as_test_preds, :test_uniq), "foo", "bar")
    end
    
    def test_predicate_replace
      src = active_sources(:assoc_predicate_test)
      src.predicate_set(:as_test_preds, :test_replace, "foo")
      src.predicate_replace(:as_test_preds, :test_replace, "bar")
      assert_property(src.predicate(:as_test_preds, :test_replace), "bar")
    end
    
    def test_direct_predicates
      preds = active_sources(:predicate_search_a).direct_predicates
      assert_equal(4, preds.size)
      assert(preds.include?('http://testvalue.org/pred_b'), "#{preds} does not include the expected value")
    end
    
    def test_inverse_predicates
      preds = active_sources(:predicate_search_b).inverse_predicates
      assert_equal(4, preds.size)
      assert(preds.include?('http://testvalue.org/pred_b'), "#{preds} does not include the expected value")
      assert_equal(0, active_sources(:predicate_search_b).direct_predicates.size)
    end
    
    def test_types
      src = ActiveSource.new
      src.uri = 'http://testy.com/testme/type_test'
      src.save!
      src.types << N::SourceClass.new(active_sources(:type_a).uri)
      src.types << N::SourceClass.new(active_sources(:type_b).uri)
      src.save!
      assert_equal(2, src.types.size)
      assert_kind_of(N::SourceClass, src.types[0])
      assert(src.types.include?(active_sources(:type_b).uri))
    end
    
    def test_sti_simple # Single table inheritance
      assert_kind_of(TaliaCore::OrderedSource, ActiveSource.find(:first, :conditions => { :uri => active_sources(:sti_source).uri }  ))
      assert_kind_of(TaliaCore::OrderedSource, active_sources(:sti_source))
    end
    
    def test_sti_relations
      assert_equal(1, active_sources(:sti_source).objects.size)
      assert_kind_of(TaliaCore::ActiveSource, active_sources(:sti_source).objects[0])
      assert_equal(active_sources(:sti_source_b).uri, active_sources(:sti_source).objects[0].uri)
    end
    
    def test_sti_relation_create
      src = active_sources(:sti_source_reltest)
      src['http://reltest_test'] << active_sources(:sti_source_reltest_b)
      src['http://reltest_test_b'] << active_sources(:sti_source_reltest_c)
      src.save!
      assert_equal(1, src['http://reltest_test'].size)
      assert_equal(1, src['http://reltest_test_b'].size)
      assert_equal(TaliaCore::OrderedSource, src['http://reltest_test'][0].class)
      assert_equal(TaliaCore::ActiveSource, src['http://reltest_test_b'][0].class)
    end
    
    def test_sti_relation_inverse
      assert_equal(1, active_sources(:sti_source_b).subjects.size)
      assert_equal(TaliaCore::OrderedSource, active_sources(:sti_source_b).subjects[0].class)
      assert_equal(TaliaCore::OrderedSource, active_sources(:sti_source_b).inverse['http://testvalue.org/sti_test'][0].class)
      assert_equal(active_sources(:sti_source).uri, active_sources(:sti_source_b).inverse['http://testvalue.org/sti_test'][0].uri)
    end
    
    def test_attach_large_and_strange_text
      src = active_sources(:strange_attach)
      src['http://strangeattach_prop'] << "Nous présentons un commentaire de l'aphorisme 103 du Voyageur et son ombre, que Nietzsche a intitulé \" Lessing \" et où l'oeuvre de cet écrivain est jugée du du point de vue du style. On ne comprend vraiment le problème que si on inscrit l'aphorisme dans le cadre de la réception par Nietzsche, dès ses années d'études, des oeuvres de Lessing. Il résulte de notre analyse que Nietzsche définit le style de Lessing en le comparant à ce que Nietzsche lui-même appelle l'école française. À l'époque du Voyageur, le concept de sérénité (Heiterkeit) dont Montaigne est le modèle, est central pour juger un style. La question est de savoir à quelle école française Lessing a appartenu. La réponse de Nietzsche est apparemment assez ambiguë : Lessing est rapproché non seulement de Bayle, de Voltaire, de Diderot et de Montaigne, mais aussi de Marivaux, de Corneille et de Racine."
      src.save!
      assert_equal(src['http://strangeattach_prop'][0],"Nous présentons un commentaire de l'aphorisme 103 du Voyageur et son ombre, que Nietzsche a intitulé \" Lessing \" et où l'oeuvre de cet écrivain est jugée du du point de vue du style. On ne comprend vraiment le problème que si on inscrit l'aphorisme dans le cadre de la réception par Nietzsche, dès ses années d'études, des oeuvres de Lessing. Il résulte de notre analyse que Nietzsche définit le style de Lessing en le comparant à ce que Nietzsche lui-même appelle l'école française. À l'époque du Voyageur, le concept de sérénité (Heiterkeit) dont Montaigne est le modèle, est central pour juger un style. La question est de savoir à quelle école française Lessing a appartenu. La réponse de Nietzsche est apparemment assez ambiguë : Lessing est rapproché non seulement de Bayle, de Voltaire, de Diderot et de Montaigne, mais aussi de Marivaux, de Corneille et de Racine.")
    end
    
    def test_attach_large_and_strange_text_fresh
      src = ActiveSource.new('http://freshstrangeattach.xml')
      src['http://strangeattach_prop'] << "Nous présentons un commentaire de l'aphorisme 103 du Voyageur et son ombre, que Nietzsche a intitulé \" Lessing \" et où l'oeuvre de cet écrivain est jugée du du point de vue du style.\nOn ne comprend vraiment le problème que si on inscrit l'aphorisme dans le cadre de la réception par Nietzsche, dès ses années d'études, des oeuvres de Lessing. Il résulte de notre analyse que Nietzsche définit le style de Lessing en le comparant à ce que Nietzsche lui-même appelle l'école française. À l'époque du Voyageur, le concept de sérénité (Heiterkeit) dont Montaigne est le modèle, est central pour juger un style. La question est de savoir à quelle école française Lessing a appartenu. La réponse de Nietzsche est apparemment assez ambiguë : Lessing est rapproché non seulement de Bayle, de Voltaire, de Diderot et de Montaigne, mais aussi de Marivaux, de Corneille et de Racine."
      src.save!
      assert_equal(src['http://strangeattach_prop'][0],"Nous présentons un commentaire de l'aphorisme 103 du Voyageur et son ombre, que Nietzsche a intitulé \" Lessing \" et où l'oeuvre de cet écrivain est jugée du du point de vue du style.\nOn ne comprend vraiment le problème que si on inscrit l'aphorisme dans le cadre de la réception par Nietzsche, dès ses années d'études, des oeuvres de Lessing. Il résulte de notre analyse que Nietzsche définit le style de Lessing en le comparant à ce que Nietzsche lui-même appelle l'école française. À l'époque du Voyageur, le concept de sérénité (Heiterkeit) dont Montaigne est le modèle, est central pour juger un style. La question est de savoir à quelle école française Lessing a appartenu. La réponse de Nietzsche est apparemment assez ambiguë : Lessing est rapproché non seulement de Bayle, de Voltaire, de Diderot et de Montaigne, mais aussi de Marivaux, de Corneille et de Racine.")
    end
    
    def test_destroy_from_predicate
      src = active_sources(:pred_destroy_test)
      assert_equal(3, src.objects.size)
      src['http://testvalue.org/pred_destroy_a'].remove
      src.save!
      assert_equal(1, active_sources(:pred_destroy_test).objects.size)
    end
    
    def test_create_local
      src = ActiveSource.new('testlocalthing')
      assert_equal(N::LOCAL.testlocalthing, src.uri)
    end
    
    def test_assign_and_save
      src = ActiveSource.new('http://testassignandsave/')
      src[N::LOCAL.something] << ActiveSource.new('http://types_test/assign_and_save_a')
      src.save!
      assert(ActiveSource.exists?(src.uri))
    end
    
    def test_assign_nil_fail
      src = ActiveSource.new('http://testassignandsave_nil/')
      assert_raise(ArgumentError) { src['rdfs:something'] << nil }
    end
    
    def test_find_through
      result = ActiveSource.find(:all, :find_through => ['http://testvalue.org/pred_find_through', active_sources(:find_through_target).uri])
      assert_equal(1, result.size)
      assert_equal(active_sources(:find_through_test), result[0])
    end
    
    def test_find_through_props
      result = ActiveSource.find(:all, :find_through => ['http://testvalue.org/pred_find_through', 'the_value'])
      assert_equal(1, result.size)
      assert_equal(active_sources(:find_through_test), result[0])
    end
    
    def test_find_through_fail
      assert_raise(ArgumentError) { ActiveSource.find(:all, :find_through => ['foo:bar', 'bar'], :joins => "LEFT JOIN something") }
      assert_raise(ArgumentError) { ActiveSource.find(:all, :find_through => ['foo:bar', 'bar'], :conditions => ["x = ?", 'bar']) }
    end
    
    def test_find_through_inv
      result = ActiveSource.find(:all, :find_through_inv => ['http://testvalue.org/pred_find_through', active_sources(:find_through_test).uri])
      assert_equal(1, result.size)
      assert_equal(active_sources(:find_through_target), result[0])
    end
    
    def test_find_through_type
      result = ActiveSource.find(:all, :type => active_sources(:find_through_type).uri)
      assert_equal(1, result.size)
      assert_equal(active_sources(:find_through_test), result[0])
    end
    
    def test_singular_accessor
      src = SingularAccessorTest.new('http://testvalue.org/singular_acc_test')
      assert_equal(nil, src.siglum)
      src.siglum = 'foo'
      src.save!
      assert_equal('foo', src.siglum)
      src.siglum = 'bar'
      assert_equal('bar', src.siglum)
    end
    
    def test_singular_accessor_finder
      src = SingularAccessorTest.new('http://testvalue.org/singular_find_test')
      src.siglum = 'foo'
      src.save!
      src2 = SingularAccessorTest.new('http://testvalue.org/singular_find_test2')
      src2.siglum = 'bar'
      src2.save!
      assert_equal(SingularAccessorTest.find_by_siglum('foo'), [ src ])
    end
    
  end
  
end
