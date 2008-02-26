module TaliaCore
  
  # A mixin for the Source class that allows it to play nicely with the 
  # will_paginate plugin. This adds a paginate method to the Source class
  # that takes the "usual" pagination parameters,
  # plus any parameters allowed for the Source#find method
  module SourcePagination
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end
    
    module ClassMethods
    
      # This takes the same options as Source#find plus any will_paginate
      # options, and return the WillPaginate::Collection for the given 
      # options. This works similiar to the pagination for ActiveRecord 
      # (meaning that options must be a hash).
      #
      # Note that this may crash if the options result in an RDF query. In this
      # case the total_entries options should be provided to the method.
      def paginate(options)
        assit_kind_of(Hash, options)
        options = options.dup # Creating the pager modifies the options, dup
                              # them so that there are no side effects on this method
        WillPaginate::Collection.create(*wp_parse_options!(options)) do |pager|
          options.update(:offset => pager.offset, :limit => pager.per_page)
        
          pager.replace(find(:all, options))
          
          pager.total_entries ||= count(options)
        end
      end
    
      # Add respond_to? paginate method
      def respond_to?(method, include_priv = false)
        if(method == :paginate)
          true
        else
          super(method, include_priv)
        end
      end
    
      protected
    
      # Largely stolen from ActiveRecord implementation
      def wp_parse_options!(options)
        raise ArgumentError, 'hash parameters expected' unless options.respond_to? :symbolize_keys!
        options.symbolize_keys!
        raise ArgumentError, ':page parameter required' unless options.key? :page
      
        page     = options.delete(:page) || 1
        per_page = options.delete(:per_page) || self.per_page
        total    = options.delete(:total_entries)
        [page, per_page, total]
      end
    
    end
  
  
  end
end