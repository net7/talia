module TaliaCore
  
  # This is an RDF query, which means that this query and all it's children will
  # act only on the RDF store.
  class RdfQuery
    
    attr_reader :limit, :offset
    attr_accessor :force_rdf
    attr_reader :operation
    
    # Create a new RdfQuery 
    def initialize(operation, *operands)
      operands.flatten!
      
      case(operation)
      when :EXPRESSION
        @property = operands[0]
        @value = operands[1]
      when :AND, :OR
        @operands = operands.collect do |op|
          raise(QueryError, "Illegal operand type #{op.class}") if(!op.is_a?(RdfQuery))
          if((operation == :AND) && op.operation == :OR)
             raise(QueryError, ":AND operations cannot have nested :OR for #{self.class}")
          end
          op
        end
      else
        raise(QueryError, "Illegal operation #{operation} for #{self.class}")
      end
      
      @operation = operation
    end
    
    # Returns a new RdfQuery that connects this query and the given one with
    # an AND operation. This will cause an error if one of the queries contains
    # nested OR operations.
    #
    # If the other query is a DbQuery, the behaviour depends on the force_rdf
    # setting: If true, this will attempt to convert the given query to an RDF
    # query and return a new RdfQuery. Otherwise, a MixedQuery will be returned.
    def and(query)
      query = get_operand(query)
      if(query.is_a?(RdfQuery))
        if((@operation == :OR) || (@operands && SourceQuery::list_contains_or?(@operands)))
          raise(QueryError, ":AND operations cannot have nested :OR")
        end
        RdfQuery.new(:AND, self, query)
      else
        # Mixed query
        MixedQuery.new(:AND, self, query)
      end
    end
    
    # Returns a new RdfQuery, connecting this query with the given one with an
    # OR operation. See the "and" operation on details for the type information
    def or(query)
      query = get_operand(query)
      if(query.is_a?(RdfQuery))
        RdfQuery.new(:OR, self, query)
      else
        MixedQuery.new(:OR, self, query)
      end
    end
    
    # Set the limit - Cannot set limits for :OR queries at the moment
    def limit=(value)
      raise(QueryError, "LIMIT for :OR queries is not supported") if(operation == :OR)
      raise(QueryError, "Illegal limit: #{value}") if(value <= 0)
      
      @limit = value
    end
    
    # Set the offset - Cannot set offset for :OR queries at the moment
    def offset=(value)
      raise(QueryError, "OFFSET for :OR queries is not supported") if(operation == :OR)
      raise(QueryError, "Illegal offset: #{value}") if(value < 0)
      
      @offset = value
    end
    
    # Executes the query. This will return a list of Source objects for the
    # elements found in the RDF store
    def execute
      raw_results = execute_raw
      raw_results.collect { |resource| Source.new(resource.uri) }
    end
    
    # Executes the "raw" query. In this case, this means that a list of 
    # RDFS::Resource objects will be returned
    # 
    # The use_limits parameter is used to enable the use of the 
    # LIMIT and OFFSET options
    def execute_raw(use_limit = true)
      case(operation)
      when :AND, :EXPRESSION
        qry = Query.new.distinct.select(:s)
        patterns = get_where_pattern
        patterns.each { |pat| qry.where(*pat) }
        qry.limit(limit) if(limit && use_limit)
        qry.offset(offset) if(offset && use_limit)
        qry.execute
      when :OR
        # Special case: combine results of all the subqueries
        # A hash is used to ensure each result is added only once 
        raw_results = {}
        @operands.each do |op|
          op_results = op.execute_raw(false)
          op_results.each { |res| raw_results[res.uri.to_sym] = res }
        end
        raw_results.values
      else
        raise(QueryError, "Illegal operation found: #{operation}")
      end
    end
    
    # Gets an array of the WHERE conditions that will be used in the 
    # underlying RDF query
    def get_where_pattern
      case(operation)
      when :EXPRESSION
        predicate = RDFS::Resource.new(@property.to_s)
        # Check if we need to treat the value as a resource
        object = if(@value.is_a?(Source)) 
          RDFS::Resource.new(@value.uri.to_s) 
        elsif(@value.kind_of?(N::URI))
          RDFS::Resource.new(@value.to_s)
        else
          @value
        end
        [[:s, predicate, object]]
      when :AND
        patterns = []
        @operands.each { |op| patterns.concat(op.get_where_pattern) }
        patterns
      else
        raise(QueryError, ":OR operations are not supported through where")
      end
    end
    
    protected
    
    # Get the new operand for creating and and or queries
    def get_operand(query)
      case(query)
      when RdfQuery
        query.force_rdf = force_rdf
      when DbQuery
        if(force_rdf)
          query = query.convert_rdf
          query.force_rdf = force_rdf
        end
      when MixedQuery
        raise(QueryError, "Cannot have MixedQuery as operand")
      else
        raise(QueryError, "Illegal query for operation: #{query.class}")
      end
      
      query
    end
    
  end
end
