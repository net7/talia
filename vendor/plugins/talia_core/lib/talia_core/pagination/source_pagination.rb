# Loader for the pagination stuff for the Source class
if(defined?(WillPaginate))
  require 'pagination/source_finder'
  
  module TaliaCore
    class Source
      SourcePagination.included(self)
    end
  end
      
  
end