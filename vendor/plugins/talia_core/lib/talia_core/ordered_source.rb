module TaliaCore
  class OrderedSource < ActiveSource
    
    # Initialize SeqContainer
    def self.new(uri)
      @resource = super(uri)
      #      @resource.save!
      #      @resource.types << RDF::Seq.uri
      #      @resource
    end
    
    # return all elements contained into SeqContainer
    #
    # return value: Array
    def elements
      # execute query
      query
    end
    
    # return the item at position index.
    # 
    #  * index: int
    #  * return value: TaliaCore::ActiveSource
    def at(index)
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
    
    private
    # execute query and return the result
    def query
      # execute query
      self.semantic_relations.find(:all, :conditions => ['predicate_uri LIKE ?', "http://www.w3.org/1999/02/22-rdf-syntax-ns#_%"], :order => :predicate_uri)
    end

    # return string for index
    def index_to_predicate(index)
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#_' + "#{index}"
    end
      
    # return index of predicate
    def predicate_to_index(predicate)
      predicate.sub('http://www.w3.org/1999/02/22-rdf-syntax-ns#_', '')
    end
    
  end
end
