module TaliaCore
  
  # This is a mixed query, which means that it contains both database and 
  # RDF queries as children.
  class MixedQuery
    
    attr_reader :operation
    
    # Create a new mixed query. This will create a query with the given 
    # operation and throw an error if the constraints are not met
    def initialize(operation, *operands)
      operands.flatten!
      
      if(operation != :AND && operation != :OR)
        raise(QueryError, "Illegal operation: #{operation} for #{self.class}") 
      end
      
      @operation = operation
      db_operands = Array.new
      rdf_operands = Array.new
      
      operands.each do |op|
        case(op)
        when DbQuery
          db_operands << op
        when RdfQuery
          rdf_operands << op
        else
          raise(QueryError, "Illegal operator type: #{op.class}")
        end
      end
      
      # We will have one query for the RDF part, and one for the db part
      @db_query = DbQuery.new(operation, db_operands)
      @rdf_query = RdfQuery.new(operation, rdf_operands)
    end
    
    # Executes the query
    def execute
      case(@operation)
      when :OR
        execute_or
      when :AND
        execute_and
      else
        raise(QueryError, "Illegal operation type #{@operation}")
      end
    end
    
    
    # Checks if the query can be converted to a pure RDF query
    # Indicates if this query can be converted to an RDF query.
    def can_convert_rdf?
      @db_query.can_convert_rdf? # Is true if the RDF query con be converted
    end
    
    # Returns an RDF query that is equivalent to this query
    def convert_rdf
      @db_query.convert_rdf
    end
    
    # Raises an error, mixed queries cannot be part of another query
    def and(query) 
      raise QueryError("Mixed queries cannot be part of other queries.")
    end
    
    # Raises an error, mixed queries cannot be part of another query
    def or(query)
      raise QueryError("Mixed queries cannot be part of other queries")
    end
    
    # Raises an error, mixed queries don't support LIMIT
    def limit=(value)
      raise QueryError("Mixed queries don't support LIMIT")
    end
    
    # Raises an error, mixed queries don't support OFFSET
    def offset=(value)
      raise QueryError("Mixed queries don't support OFFSET")
    end
    
    protected
    
    # This is used for mixed :AND queries
    def execute_and
      # Find the resources from RDF
      resources = @rdf_query.execute.collect { |res| res.uri.to_s }
      # Build the SQL query condition
      conditions = @db_query.get_conditions()
      conditions << " AND ( " << SourceRecord::sanitize_sql({:uri => resources}) << " )"
      opts = {}
      opts[:conditions] = conditions
      source_records = SourceRecord.find(:all, opts)
      source_records.collect { |res| Source.new(res) }
    end
    
    # This is used for mixed :OR queries
    def execute_or
      # We use a hash to eliminate duplicate results
      result_hash = {}
      # First add the rdf results 
      @rdf_query.execute.collect { |res| result_hash[res.uri.to_s.to_sym] = res }
      # Then add the db results
      @db_query.execute.collect { |s_rec| result_hash[s_rec.uri.to_s.to_sym] = s_rec }
      result_hash.values
    end
    
  end
end
