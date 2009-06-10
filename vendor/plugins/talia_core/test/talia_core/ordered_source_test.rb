# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the ActiveSource
  class OrderedSourceTest < Test::Unit::TestCase
    
    #    fixtures :active_sources, :semantic_properties, :semantic_relations
     
    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_db
        TaliaUtil::Util.flush_rdf
        true
      end
    end
    
    def test_resource_type
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/type')
      # check class
      assert_kind_of OrderedSource, ordered_source
      # check type
      #      assert_equal 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Seq', ordered_source.types.to_s
    end
    
    def test_elements
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/elenments')
      ordered_source.save!
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      ordered_source[(RDF::_000001).uri].add_with_order(item_1, 1)
      ordered_source[(RDF::_000002).uri].add_with_order(item_2, 2)
      ordered_source[(RDF::_000003).uri].add_with_order(item_3, 3)
      ordered_source.save!
      
      # check if all items are inserted
      assert_equal 3, ordered_source.elements.size
      assert_equal item_1.uri, ordered_source.elements[0].uri
      assert_equal item_2.uri, ordered_source.elements[1].uri
      assert_equal item_3.uri, ordered_source.elements[2].uri
    end
    
    def test_add
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
       
      # add item to ordered source
      ordered_source.add item_1
      ordered_source.save!
      
      # check if all items are inserted
      assert_equal 1, ordered_source.elements.size
      assert_equal item_1.uri, ordered_source.elements[0].uri
      
      ordered_source.add item_2
      ordered_source.save!
      
      # check if all items are inserted
      assert_equal 2, ordered_source.elements.size
      assert_equal item_1.uri, ordered_source.elements[0].uri
      assert_equal item_2.uri, ordered_source.elements[1].uri
    end
    
    def test_remove
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set_remove')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
       
      # add items to ordered source
      ordered_source.add item_1
      ordered_source.add item_2
      
      # check if all items are inserted
      assert_equal 2, ordered_source.elements.size
      assert_equal item_1.uri, ordered_source.elements[0].uri
      assert_equal item_2.uri, ordered_source.elements[1].uri
      
      # test delete item 1
      ordered_source.delete 1
      
      # check if item1 is been deleted
      assert_equal 1, ordered_source.elements.size
      assert_equal item_2.uri, ordered_source.elements[0].uri
      
      # test delete item 1
      ordered_source.delete 1
      ordered_source.save!
      
      # check if item1 is been deleted
      assert_equal 0, ordered_source.elements.size
      
      # add items to ordered source
      ordered_source.add item_1
      ordered_source.add item_2
      
      # delete all item
      ordered_source.delete_all
      
      # check if all items are been deleted
      assert_equal 0, ordered_source.elements.size
      assert ordered_source.elements.empty?
    end
    
        
    def test_replace
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/replace')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
       
      # add items to ordered source
      ordered_source.add item_1
      ordered_source.add item_2
      
      # check if all items are inserted
      assert_equal 2, ordered_source.elements.size
      assert_equal item_1.uri, ordered_source.elements[0].uri
      assert_equal item_2.uri, ordered_source.elements[1].uri
      
      # test delete item 1
      ordered_source.replace 1,item_3
      
      # check if item1 is been replaced
      assert_equal 2, ordered_source.elements.size
      assert_not_equal item_1.uri, ordered_source.elements[0].uri
      assert_equal item_3.uri, ordered_source.elements[0].uri
      assert_equal item_2.uri, ordered_source.elements[1].uri
    end
    
    def test_size
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/size')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, ordered_source.size
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      ordered_source.insert_at(101, item_1)
      ordered_source.insert_at(103, item_3)
      ordered_source.insert_at(102, item_2)

      # the size must be 104 (counting the 0-element
      assert_equal 104, ordered_source.size
    end
    
    def test_at
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/at')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, ordered_source.size
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      ordered_source.add item_1
      ordered_source.add item_2
      ordered_source.add item_3
      
      # check at method
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(1)
      assert_equal item_1.uri, ordered_source.at(1).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(2)
      assert_equal item_2.uri, ordered_source.at(2).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(3)
      assert_equal item_3.uri, ordered_source.at(3).uri
    end
    
    def test_add_more_then_10_items
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/tenit')
      ordered_source.save!
      assert_equal 0, ordered_source.elements.size, "#{ordered_source.elements.collect { |el| el.uri }}"
      
      # the size must be 0
      assert_equal 0, ordered_source.size
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      item_4 = ActiveSource.new('http://testvalue.org/item_4')
      item_5 = ActiveSource.new('http://testvalue.org/item_5')
      item_6 = ActiveSource.new('http://testvalue.org/item_6')
      item_7 = ActiveSource.new('http://testvalue.org/item_7')
      item_8 = ActiveSource.new('http://testvalue.org/item_8')
      item_9 = ActiveSource.new('http://testvalue.org/item_9')
      item_10 = ActiveSource.new('http://testvalue.org/item_10')
      item_11 = ActiveSource.new('http://testvalue.org/item_11')
      item_12 = ActiveSource.new('http://testvalue.org/item_12')
      
      # add items to OrderedSource
      ordered_source.add item_1
      ordered_source.add item_2
      ordered_source.add item_3
      ordered_source.add item_4
      ordered_source.add item_5
      ordered_source.add item_6
      ordered_source.add item_7
      ordered_source.add item_8
      ordered_source.add item_9
      ordered_source.add item_10
      ordered_source.add item_11
      ordered_source.add item_12
      
      # check at method
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(1)
      assert_equal item_1.uri, ordered_source.at(1).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(2)
      assert_equal item_2.uri, ordered_source.at(2).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(3)
      assert_equal item_3.uri, ordered_source.at(3).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(4)
      assert_equal item_4.uri, ordered_source.at(4).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(5)
      assert_equal item_5.uri, ordered_source.at(5).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(6)
      assert_equal item_6.uri, ordered_source.at(6).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(7)
      assert_equal item_7.uri, ordered_source.at(7).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(8)
      assert_equal item_8.uri, ordered_source.at(8).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(9)
      assert_equal item_9.uri, ordered_source.at(9).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(10)
      assert_equal item_10.uri, ordered_source.at(10).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(11)
      assert_equal item_11.uri, ordered_source.at(11).uri
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(12)
      assert_equal item_12.uri, ordered_source.at(12).uri
      
      # test order
      elements = ordered_source.elements.collect { |el| el.uri }
      elements_array = []
      elements_array << 'http://testvalue.org/item_1'
      elements_array << 'http://testvalue.org/item_2'
      elements_array << 'http://testvalue.org/item_3'
      elements_array << 'http://testvalue.org/item_4'
      elements_array << 'http://testvalue.org/item_5'
      elements_array << 'http://testvalue.org/item_6'
      elements_array << 'http://testvalue.org/item_7'
      elements_array << 'http://testvalue.org/item_8'
      elements_array << 'http://testvalue.org/item_9'
      elements_array << 'http://testvalue.org/item_10'
      elements_array << 'http://testvalue.org/item_11'
      elements_array << 'http://testvalue.org/item_12'
      assert_equal elements_array, elements
    end
    
    def test_next_and_previous
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/nextprev')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, ordered_source.size
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      ordered_source.add item_1
      ordered_source.add item_2
      ordered_source.add item_3
      
      # test next method
      item = ordered_source.at(2)
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(2)
      assert_equal item_2.uri, ordered_source.at(2).uri
      assert_equal 2, ordered_source.current_index
      
      @next = ordered_source.next
      assert_kind_of TaliaCore::ActiveSource, @next
      assert_equal item_3.uri, @next.uri
      assert_equal 3, ordered_source.current_index
      
      assert_raise(RuntimeError) {ordered_source.next}
      assert_equal 3, ordered_source.current_index
            
      # test previous method
      item = ordered_source.at(2)
      assert_kind_of TaliaCore::ActiveSource, ordered_source.at(2)
      assert_equal item_2.uri, ordered_source.at(2).uri
      assert_equal 2, ordered_source.current_index
      
      @previous = ordered_source.previous
      assert_kind_of TaliaCore::ActiveSource, @previous
      assert_equal item_1.uri, @previous.uri
      assert_equal 1, ordered_source.current_index
      
      assert_raise(RuntimeError) {ordered_source.previous}
      assert_equal 1, ordered_source.current_index
      
      # test next with index
      @next = ordered_source.next(2)
      assert_kind_of TaliaCore::ActiveSource, @next
      assert_equal item_3.uri, @next.uri
      assert_equal 3, ordered_source.current_index
      
      assert_raise(RuntimeError) {ordered_source.next(3)}
      assert_equal 3, ordered_source.current_index
      
      # test next with element
      @next = ordered_source.next(item_2)
      assert_kind_of TaliaCore::ActiveSource, @next
      assert_equal item_3.uri, @next.uri
      assert_equal 3, ordered_source.current_index
      
      # test previous with index
      @previous = ordered_source.previous(2)
      assert_kind_of TaliaCore::ActiveSource, @previous
      assert_equal item_1.uri, @previous.uri
      assert_equal 1, ordered_source.current_index
      
      assert_raise(RuntimeError) {ordered_source.previous(1)}
      assert_equal 1, ordered_source.current_index

      # test previous with element
      @previous = ordered_source.previous(item_2)
      assert_kind_of TaliaCore::ActiveSource, @previous
      assert_equal item_1.uri, @previous.uri
      assert_equal 1, ordered_source.current_index

    end
    
    def test_find_ordered_source
      # create new OrderedSource
      ordered_source = OrderedSource.new('http://testvalue.org/ordered_set/find')
      ordered_source.save!
      assert ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, ordered_source.size
      
      # create 3 items
      item_1 = ActiveSource.new('http://testvalue.org/item_1')
      item_2 = ActiveSource.new('http://testvalue.org/item_2')
      item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      ordered_source.add item_1
      ordered_source.add item_2
      ordered_source.add item_3
      
      # test find method
      assert_equal 2, ordered_source.find_position_by_object(item_2)
    end

    def test_save_reload
      ordered = OrderedSource.new('http://orderedsource_save_and_load')
      item_1 = ActiveSource.new('http://orderedsource_save_and_load/item')
      ordered.insert_at(15, item_1)
      assert_equal(item_1, ordered.at(15))
      ordered.save!
      reload = OrderedSource.find(ordered.id)
      assert_equal(item_1, reload.at(15))
    end

  end
end
