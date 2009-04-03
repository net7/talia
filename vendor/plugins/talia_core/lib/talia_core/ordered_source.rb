module TaliaCore

  # This class provides an ordering on the related sources. It will load the
  # related elements into an array. All changes made to the OrderedSource will
  # reflect on the Array, and will only be persisted to the store on save.
  #
  # The collection is contained in the ordered_objects - if you ever use that
  # accessor all "ordering" relations for the object will be completely overwritten
  # on saving. (You can still assign the predicates manually as long as the
  # ordered_objects accesssor is not called before saving.)
  class OrderedSource < ActiveSource
    
    attr_reader :current_index

    before_save :rewrite_order_relations

    # Initialize SeqContainer
    def self.new(uri)
      @resource = super(uri)
      #      @resource.save!
      #      @resource.types << RDF::Seq.uri
      #      @resource
    end
    
    # Returns all elements (not the relations) in an ordered array. Unlike the
    # ordered_objects accessor this will not include nil elements and the
    # index will not have a 1:1 relation to the position of the elment.
    #
    # The ordering of the elements will be preserved, though.
    def elements
      # execute query
      ordered_objects.compact
    end
    
    # Returns the first element of the collection
    def first
      ordered_objects.find { |el| !el.nil? }
    end
    
    # return the item at position index.
    # 
    #  * index: int
    #  * return value: TaliaCore::ActiveSource
    def at(index)
      @current_index = index
      ordered_objects.at(index)
    end
    
    # return next item
    # * current_element: int or string. Current element. If nil, the index is the last integer used with at method
    def next(current_element = nil)
      set_current_index_for(current_element)
      
      # if current element is nil, next must return first value
      @current_index ||= 0
      
      if (@current_index < (size - 1))
        return at(@current_index + 1) # TODO: Current is not increased, is this intentional? Do we need this method at all?
      else
        raise "Last item reached"
      end
    end

    # return previous item
    # * current_element: int or string. Current element. If nil, the index is the last integer used with at method
    def previous(current_element = nil)
      set_current_index_for(current_element)
      
      # if current element is nil, next must return first value
      @current_index = (size + 1) if @current_index.nil?
      
      if (@current_index > 1) # TODO: This assumes a one-base array, not really useful
        return at(@current_index - 1) # TODO: See above
      else
        raise "First item reached"
      end
    end
    
    # Return the "size" of the collection. This is actually the maximum position
    # index that is used. The value is cached internally and will be increased
    # on insert_at (only if inserting at a value larger at the current size) and
    # on the add operation. If elements are added in another way, the count
    # may be off, but in that case it would be off anyway. Delete will decrease
    # the size by 1, if the index removed equals the size (this is a rough guess
    # which may be off!)
    # The cached counter will be reset on saving.
    def size
      ordered_objects.size
    end
    
    # Inserts an element at the given index.
    def insert_at(index, object)
      write_for_index(ordered_objects, index, object)
    end
    
    # Add new item to ordered source. This will add the object after the last
    # element. ATTENTION: If you add on an empty collection, it will start at
    # index 1 (One), for backwards compatability
    def add(object)
      position = (size > 0) ? size : 1
      insert_at(position, object)
    end
    
    # remove an existing object to ordered source. This will reorder the
    # existing positions if deleting from the middle! If you don't want
    # that use insert_at(index, nil)
    def delete(index)
      ordered_objects.delete_at(index)
    end
  
    # remove all existing object to ordered source
    # TODO: This will not reliably delete all elements, since the size
    #       value is not reliable
    def delete_all
      @ordered_objects = []
    end
    
    # replace item as position index with object
    # * index: int
    # * object: TaliaCore::ActiveSource
    def replace(index, object)
      replace_for_index(ordered_objects, index, object)
    end
    
    # Find the position index of the given object. This will always find the
    # first occurence
    def find_position_by_object(object)
      ordered_objects.index(object)
    end

    # return string for index
    def index_to_predicate(index)
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#_' << ("%06d" % index.to_i) 
    end
      
    # return index of predicate
    def predicate_to_index(predicate)
      predicate.sub('http://www.w3.org/1999/02/22-rdf-syntax-ns#_', '').to_i
    end
    
    # Returns all the objects that are ordered in an array where the array
    # index equals the position of the object in the ordered set. The array
    # is zero-based, position that don't have an object attached will be set to 
    # nil.
    def ordered_objects
      return @ordered_objects if(@ordered_objects)
      relations = query
      # Let's assume the follwing is a sane assumption ;-)
      # Even if a one-base collection comes in, we need to push just one element
      @ordered_objects = Array.new(relations.size)
      # Now add the elements so that the relation property is reflected
      # on the position in the array
      relations.each do |rel|
        index = predicate_to_index(rel.predicate_uri)
        write_for_index(@ordered_objects, index, rel.object)
      end

      @ordered_objects
    end

    private

    # Set the current index for the given element, which can be a number, a
    # predicate string or an object contained in the collection. Passing nil
    # causes it to do nothing.
    def set_current_index_for(current_element)
      return unless(current_element)

      case current_element
      when Fixnum   then @current_index = current_element
      when String   then @current_index = predicate_to_index(current_element)
      when TaliaCore::ActiveSource
        # find semantic relation
        pos = find_position_by_object(current_element)
        # if no relations is found
        raise "Object isn't in current OrderedSource" if pos.nil?
        # else we have a position
        @current_index = pos
      else
        raise "Class #{current_element.class} not supported"
      end
    end

    # This will be called before saving and will completely rewrite the relations
    # that make up the ordered store, based on the internal array
    def rewrite_order_relations
      return unless(@ordered_objects) # If this is nil, the relations weren't loaded in the first place
      objects = elements # Fetch them before deleting
      # Now destroy the existing elements
      SemanticRelation.destroy_all(['subject_id = ? AND predicate_uri LIKE ?', self.id, "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%"])
      # rewrite from the relations array
      objects.each_index do |index|
        if(obj = objects.at(index)) # Check if there's a value to handle
          self[index_to_predicate(index)] << obj
        end
      end
    end

    # Helper to "grow" an array to the given index. Unless replace is true, it
    # will raise an error if the element already exists.
    def write_for_index(arr, index, value, replace = false)
      raise(RuntimeError, "Duplicate element found on index #{index}") if(arr.at(index) && !replace)
      arr[index] = value
    end
    
    def replace_for_index(arr, index, value)
      write_for_index(arr, index, value, true)
    end

    # execute query and return the result
    def query(scope = :all)
      # execute query
      self.semantic_relations.find(scope, :conditions => ['predicate_uri LIKE ?', "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%"], :order => :predicate_uri)
    end
    
  end
end
