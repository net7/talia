require 'query/rdf_query'
require 'query/mixed_query'
require 'query/db_query'

module TaliaCore
  # This encapsulates a query for Talia Sources. The actual queries will not
  # be SourceQuery objects, see below.
  #
  # The queries are built like a tree, with one "root" query and any number of
  # child queries. A query can be either an _expression_, which means that it
  # contains just a simple "property = value" expression, or it can be a 
  # _operation_. Operations can be :AND and :OR, each operation has any number
  # of expressions or other operations as child queries.
  #
  # There can not be objects of SourceQuery directly - this is only a factory
  # class to create query objects. For technical reasons, the created queries
  # are *not* subclasses of SourceQuery. However, they should satisfy the
  # following requirements: 
  # 
  # * They have an execute() method that returns a list of Source objects found
  #   by the query
  # * They respond to the and(), or(), limit() and offset() methods - this
  #   doesn't mean that the operations are always supported, just that the
  #   queries will respond to the methods, and raise a sensible error if
  #   the operation is not supported
  class SourceQuery
    
    # Indicates the operation that this query performs on it's operands
    # This can be :AND, :OR or :EXPRESSION
    # In the latter case, this query is a simple expression - otherwise
    # it's operands or other Queries.
    attr_reader :operation
        
    # Initialize a new query. The syntax is
    # <tt>SourceQuery.new(:operation => op, :options => {...}, :conditions => {...})</tt> or
    # <tt>SourceQuery.new(:operation => :EXPRESSION, :property => prop, :value => val)</tt>
    #
    # The operation option selects the type of query that is created. The default
    # operation is :AND.
    # 
    # If :EXPRESSION is selected for the operation, a property and value can
    # be provided to create a simple "WHERE property = value" expression.
    # 
    # Otherwise, a hash of property-value pairs must be provided as :conditions,
    # and the expressions from this hash will be joined by the :operation.
    # 
    # If the value of an operation is an Array, it will be treated as if multiple
    # property-value pairs with the same property are given.
    #
    # ==Options
    # 
    # * <tt>:limit</tt> - Limit the result set to the given number
    # * <tt>:offset</tt> - Set the offset for a limited result set
    # * <tt>:force_rdf</tt> - Try to force an RDF-only query.
    def self.new(params)
      result = nil
      operation = params[:operation] ? params[:operation] : :AND
      
      case(operation)
      when :EXPRESSION
        if(!params[:property] || !params[:value] || params[:conditions])
          raise QueryError("Illegal params for :EXPRESSION")
        end
        result = create_expression(params[:property], params[:value], params[:force_rdf])
      when :AND, :OR
        if(!params[:conditions] || params[:value] || params[:property])
          raise(QueryError, "Illegal params for #{operation}")
        end
        result = create_expressions(operation, params[:conditions], params[:force_rdf])
      else
        raise(QueryError, "Illegal operation #{operation}")
      end
      
      result.limit = params[:limit] if(params[:limit])
      result.offset = params[:offset] if(params[:offset])
      result
    end
    
    # Some helper methods for public use
    # Convert a db property into an RDF property
    class << self
      # Indicates if the given query item has to be queried in the database.
      def is_db_item(item)
        item == :type ||
          SourceRecord.column_names.include?(item.to_s)
      end

      # True if the list of queries contains an :OR query
      def list_contains_or?(list)
        list.detect { |qry| qry.operation == :OR } != nil
      end

      # True if all queries in the list can be forced to RDF
      def list_can_convert_rdf?(list)
        list.detect { |qry| !qry.can_convert_rdf? } == nil
      end
    end
    
    
    protected
    
    # Creates a query with the given list of conditions and the given operation.
    def self.create_expressions(operation, conditions, force_rdf = false)
      tmp_type = nil
      
      queries = []
      conditions.each do |property, value|
        if(value.kind_of?(Array))
          value.each do |sub_value|
            expr = create_expression(property, sub_value, force_rdf)
            tmp_type = expr.class if(!tmp_type) # To init the type
            tmp_type = MixedQuery if(tmp_type != expr.class)
            queries << expr
          end
        else
          expr = create_expression(property, value, force_rdf)
          tmp_type = expr.class if(!tmp_type) # To init the type
          tmp_type = MixedQuery if(tmp_type != expr.class)
          queries << expr
        end
        
      end
      
      query = tmp_type.new(operation, queries)
      query.force_rdf = force_rdf if(query.is_a?(RdfQuery))
      
      query
    end
    
    # Creates a new simple expression query of the correct type. Forces 
    # the type to RDF if neccessary
    def self.create_expression(property, value, force_rdf = false)
      query = nil
      
      if(!is_db_item(property))
        query = RdfQuery.new(:EXPRESSION, property, value)
        query.force_rdf = force_rdf
      else
        query = DbQuery.new(:EXPRESSION, property, value)
        if(force_rdf)
          query = query.convert_rdf
          query.force_rdf = true
        end
      end
      
      query
    end
    
  end
end