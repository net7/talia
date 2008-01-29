require 'paginator'

# A paginator extending the default "Paginator" functionality with things used
# for paginating sources.
class SourcePaginator < Paginator
  attr_reader :query_options
  
  
  # Create a new paginator with the given  
  # options. The block for this Paginator will automatically be constructed
  # from a TaliaCore::Source#find with the given query options.
  #
  # This creates a new paginator with the given count and elements per_page. 
  # The query options are optional.
  def initialize(count, per_page, query_options = {})
    @query_options = query_options
    super(count, per_page) do |offset, n_per_page|
      # Add limit and offset to the given options
      TaliaCore::Source.find(:all, query_options.merge({:limit => n_per_page, :offset => offset}))
    end
  end
  
  # Return the state as a hash, giving the count, per_page and query_options
  def state
    { :count => count, :per_page => per_page, :query_options => @query_options }
  end
  
end