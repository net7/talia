# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the ActiveSource
  class ActiveSourceTest < Test::Unit::TestCase
    
    #    fixtures :active_sources, :semantic_properties, :semantic_relations
     
    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_db
        TaliaUtil::Util.flush_rdf
        true
      end
    end
    
    def test_resource_type
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      # check class
      assert_kind_of OrderedSource, @ordered_source
      # check type
      #      assert_equal 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Seq', @ordered_source.types.to_s
    end
    
    def test_elements
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
      @item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      @ordered_source[(RDF::_1).uri] << @item_1
      @ordered_source[(RDF::_2).uri] << @item_2
      @ordered_source[(RDF::_3).uri] << @item_3
      
      # check if all items are inserted
      assert_equal 3, @ordered_source.elements.size
      assert_equal @item_1.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_2.uri, @ordered_source.elements[1].object.uri
      assert_equal @item_3.uri, @ordered_source.elements[2].object.uri
    end
    
    def test_add
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
       
      # add item to ordered source
      @ordered_source.add @item_1
      
      # check if all items are inserted
      assert_equal 1, @ordered_source.elements.size
      assert_equal @item_1.uri, @ordered_source.elements[0].object.uri
      
      @ordered_source.add @item_2
      # check if all items are inserted
      assert_equal 2, @ordered_source.elements.size
      assert_equal @item_1.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_2.uri, @ordered_source.elements[1].object.uri
    end
    
    def test_remove
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
       
      # add items to ordered source
      @ordered_source.add @item_1
      @ordered_source.add @item_2
      
      # check if all items are inserted
      assert_equal 2, @ordered_source.elements.size
      assert_equal @item_1.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_2.uri, @ordered_source.elements[1].object.uri
      
      # test delete item 1
      @ordered_source.delete 1
      
      # check if item1 is been deleted
      assert_equal 1, @ordered_source.elements.size
      assert_equal @item_2.uri, @ordered_source.elements[0].object.uri
      
      # test delete item 1
      @ordered_source.delete 2
      
      # check if item1 is been deleted
      assert_equal 0, @ordered_source.elements.size
      
      # add items to ordered source
      @ordered_source.add @item_1
      @ordered_source.add @item_2
      
      # delete all item
      @ordered_source.delete_all
      
      # check if all items are been deleted
      assert_equal 0, @ordered_source.elements.size
      assert @ordered_source.elements.empty?
    end
    
        
    def test_replace
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
      @item_3 = ActiveSource.new('http://testvalue.org/item_3')
       
      # add items to ordered source
      @ordered_source.add @item_1
      @ordered_source.add @item_2
      
      # check if all items are inserted
      assert_equal 2, @ordered_source.elements.size
      assert_equal @item_1.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_2.uri, @ordered_source.elements[1].object.uri
      
      # test delete item 1
      @ordered_source.replace 1,@item_3
      
      # check if item1 is been replaced
      assert_equal 2, @ordered_source.elements.size
      assert_not_equal @item_1.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_3.uri, @ordered_source.elements[0].object.uri
      assert_equal @item_2.uri, @ordered_source.elements[1].object.uri
    end
    
    def test_size
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, @ordered_source.size
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
      @item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      @ordered_source[(RDF::_101).uri] << @item_1
      @ordered_source[(RDF::_103).uri] << @item_3
      @ordered_source[(RDF::_102).uri] << @item_2

      # the size must be 103
      assert_equal 103, @ordered_source.size
    end
    
    def test_at
      # create new OrderedSource
      @ordered_source = OrderedSource.new('http://testvalue.org/ordered_set')
      @ordered_source.save!
      assert @ordered_source.elements.empty?
      
      # the size must be 0
      assert_equal 0, @ordered_source.size
      
      # create 3 items
      @item_1 = ActiveSource.new('http://testvalue.org/item_1')
      @item_2 = ActiveSource.new('http://testvalue.org/item_2')
      @item_3 = ActiveSource.new('http://testvalue.org/item_3')
      
      # add items to OrderedSource
      @ordered_source.add @item_1
      @ordered_source.add @item_2
      @ordered_source.add @item_3
      
      # check at method
      assert_kind_of TaliaCore::ActiveSource, @ordered_source.at(1)
      assert_equal @item_1.uri, @ordered_source.at(1).uri
      assert_kind_of TaliaCore::ActiveSource, @ordered_source.at(2)
      assert_equal @item_2.uri, @ordered_source.at(2).uri
      assert_kind_of TaliaCore::ActiveSource, @ordered_source.at(3)
      assert_equal @item_3.uri, @ordered_source.at(3).uri
    end  
  end
  
end
