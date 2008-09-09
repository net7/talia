module TaliaCore
  class OrderedSource < ActiveSource
    
    attr_reader :current_index
    
    # Initialize SeqContainer
    def self.new(uri)
      @resource = super(uri)
      #      @resource.save!
      #      @resource.types << RDF::Seq.uri
      #      @resource
    end
    
    # Returns all elements (not the relations) in an ordered array.
    def elements
      # execute query
      query.collect { |relation| relation.object }
    end
    
    # Returns the first element of the collection
    def first
      relation = query(:first)
      relation ? relation.object : nil
    end
    
    # return the item at position index.
    # 
    #  * index: int
    #  * return value: TaliaCore::ActiveSource
    def at(index)
      @current_index = index
      # get predicate for next item
      predicate =  index_to_predicate(index)

      # add new object to ordered set
      result = self[predicate]
      
      # raise exception if there are more than one item
      raise "Predicate at position #{index} contain more then one item." if result.size > 1
      
      # return first item
      if result.empty?
        # if there aren't result, return nil
        nil
      else
        # return first item
        result.first
      end
    end
    
    # return next item
    # * current_element: int or string. Current element. If nil, the index is the last integer used with at method
    def next(current_element = nil)
      # check current_element item class
      unless current_element.nil?
        case current_element
        when Fixnum   then @current_index = current_element
        when String   then @current_index = predicate_to_index(current_element)
        when TaliaCore::ActiveSource
          # find semantic relation
          pos = find_position_by_object(current_element)
          # if no relations is found
          if pos.nil?
            raise "Object isn't in current OrderedSource"
            # if many relation is found
          elsif pos.is_a?(Array)
            raise "Found more the one object in current OrderedSource"
            # if one relation is found
          else
            @current_index = pos
          end
        else
          raise "Class #{current_element.class} not supported"
        end
      end
      
      # if current element is nil, next must return first value
      @current_index = 0 if @current_index.nil?
      
      if (@current_index < size)
        return at(@current_index + 1)
      else
        raise "Last item reached"
      end
    end

    # return previous item
    # * current_element: int or string. Current element. If nil, the index is the last integer used with at method
    def previous(current_element = nil)
      # check current_element item class
      unless current_element.nil?
        case current_element
        when Fixnum   then @current_index = current_element
        when String   then @current_index = predicate_to_index(current_element)
        when TaliaCore::ActiveSource
          # find semantic relation
          pos = find_position_by_object(current_element)
          # if no relations is found
          if pos.nil?
            raise "Object isn't in current OrderedSource"
            # if many relation is found
          elsif pos.is_a?(Array)
            raise "Found more the one object in current OrderedSource"
            # if one relation is found
          else
            @current_index = pos
          end
        else
          raise "Class #{current_element.class} not supported"
        end
      end
      
      # if current element is nil, next must return first value
      @current_index = (size + 1) if @current_index.nil?
      
      if (@current_index > 1)
        return at(@current_index - 1)
      else
        raise "First item reached"
      end
    end
    
    # return size of SeqContainer
    #
    # return value: int
    def size
      result = query

      if result.empty?
        return 0
      else
        # convert all predicate into integer
        index = result.collect { |item| predicate_to_index(item.predicate_uri).to_i  }
        return index.max.to_i
      end
    end
    
    # add new item to ordered source
    # * object = TaliaCore::ActiveSource
    def add(object)
      # get predicate for next item
      predicate =  index_to_predicate(size + 1)

      # add new object to ordered set
      self[predicate] << object
    end
    
    # remove an existing object to ordered source
    # * index: int
    def delete(index)
      # get predicate to delete
      predicate = index_to_predicate(index)
    
      # delete item
      self[predicate].remove
    end
  
    # remove all existing object to ordered source
    def delete_all
      # call delete method
      (1..size).each do |index|
        self.delete(index)
      end
    end
    
    # replace item as position index with object
    # * index: int
    # * object: TaliaCore::ActiveSource
    def replace(index, object)
      # delete item
      self.delete(index)
      
      # get predicate for index
      predicate =  index_to_predicate(index)
      
      # add item
      self[predicate] << object
    end
    
    # returns the object position
    # return value is Fixnum if only one relation is found for current ordered source, otherwise it will be an Array of Fixnum
    def find_position_by_object(object)
      # find semantic relation with predicate that match with string and object_id is 'object'
      result = self.semantic_relations.find(:all, :conditions => ['(predicate_uri LIKE ?) AND (object_id = ?)', "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%", object.id], :order => :predicate_uri)
      # if object is not found, return nil
      if result.empty?
        return nil
      elsif result.size == 1
        return predicate_to_index(result[0].predicate_uri)
      else
        result.collect {|item| predicate_to_index(item.predicate_uri) }
      end
      
      #result = self.semantic_relations.find(:all) #, :conditions => ['predicate_uri LIKE ?', "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%"]).uniq
      #result.collect { |item| OrderedSource.new item.subject.uri}
    end
    
    private
    # execute query and return the result
    def query(scope = :all)
      # execute query
      self.semantic_relations.find(scope, :conditions => ['predicate_uri LIKE ?', "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%"], :order => :predicate_uri)
    end

    # return string for index
    def index_to_predicate(index)
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#_' + "#{("000000" + index.to_s)[-6..-1]}"
    end
      
    # return index of predicate
    def predicate_to_index(predicate)
      predicate.sub('http://www.w3.org/1999/02/22-rdf-syntax-ns#_', '').to_i
    end
    
  end
end
