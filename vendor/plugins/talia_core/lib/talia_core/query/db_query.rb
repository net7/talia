module TaliaCore
  
  # This is database query, which means that this query and all child queries
  # will act only on the SQL database
  # 
  # TODO: At the moment, it will only do joins/relational queries for :type
  #       information. Maybe automatic deduction of relationships is needed?
  class DbQuery
    
    attr_accessor :limit, :offset
    attr_reader :operation
    
    # Creates a new dabase query with the given operation and operands.
    # If the operation is :EXPRESSION, then the first operator is the property
    # and the second the value. Otherwise, the operands must be a list of
    # DbQueries.
    def initialize(operation, *operands)
      operands.flatten!
      
      case(operation)
      when :EXPRESSION
        @property = operands[0]
        @value = operands[1]
      when :AND, :OR
        # Check the operands
        @operands = operands.collect do |op|
          raise QueryError("Illegal operand type: #{op_type}") if(!op.is_a?(DbQuery))
          op
        end
      else
        raise QueryError("Illegal operation: #{operation}")
      end
      
      @operation = operation
    end
    
    
    # Returns the WHERE conditions for this query
    def get_conditions
      case(operation)
      when :EXPRESSION
        if(@property == :type)
          SourceRecord::sanitize_sql(["id IN (SELECT source_record_id FROM type_records WHERE uri = ?)", @value.to_s])
        else
          SourceRecord::sanitize_sql(@property => @value)
        end
      when :AND, :OR
        fragment = ""
        @operands.each_index do |idx| 
          if(idx == 0)
            fragment = @operands[idx].get_conditions
          else
            fragment += " #{operation.to_s} #{@operands[idx].get_conditions} "
          end
        end
        "( #{fragment} )"
      else
        raise QueryError("Illegal operation: #{operation}")
      end
    end
    
    
    # Excecutes the query
    def execute
      # Build a new Source from the result set
      execute_raw.collect { |res| Source.new(res) }
    end
    
    # Executes the query and returns the "raw" results, in this case
    # the records from the ActionRecord finder
    def execute_raw
      opts = {}
      opts[:conditions] = get_conditions()
      opts[:limit] = limit if(limit)
      opts[:offset] = offset if(offset)
      SourceRecord.find(:all, opts)
    end
    
    # Gets a count of the result, *IGNORING* any limit (or offset) conditions
    # that may be set
    def result_count_all
      sql = "SELECT COUNT(*) FROM source_records WHERE #{get_conditions()} "
      sql += "LIMIT #{limit} " if(limit)
      SourceRecord.count_by_sql(sql)
    end
    
    # Indicates if this query can be converted to an RDF query.
    def can_convert_rdf?
      return true if(operation == :EXPRESSION) # expressions can always be converted
      
      # Constraint for RDF is: An AND query cannot have nested OR queries
      can_force = (operation != :AND) || !SourceQuery::list_contains_or?(@operands)
      
      # If all is ok, check the operands recursively
      can_force && SourceQuery::list_can_convert_rdf?(@operands) 
    end
    
    # Returns an RDF query that is equivalent to this query
    def convert_rdf
      raise QueryError("Cannot convert to RDF query") if(!can_convert_rdf?)
      
      if(operation == :EXPRESSION)
        RdfQuery.new(:EXPRESSION, [Source::db_item_to_rdf(@property), @value])
      else
        RdfQuery.new(operation, @operands.collect { |op| op.convert_rdf })
      end
    end
    
    # Returns a new DbQuery that connects this query and the given one with
    # an AND operation. The given query must also be a DbQuery
    def and(query)
      DbQuery.new(:AND, self, query)
    end
    
    # Returns a new DbQuery, connecting this query with the given one with an
    # OR operation. The given query must also be a DbQuery
    def or(query)
      DbQuery.new(:OR, self, query)
    end
    
  end
end
