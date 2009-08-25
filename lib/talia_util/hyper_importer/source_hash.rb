module TaliaUtil
  module HyperImporter
    
    # Some small helper classes to store the structure during the import
    module SourceHash

      # Master hash, stores one entry per source
      class MasterHash < Hash
        def [](key)
          key = TaliaCore::ActiveSource.expand_uri(key)
          unless(value = super(key))
            value = (store(key, SrcHash.new(key)))
          end
          assit_equal(key.to_s, value[:uri].to_s)
          value
        end
        
        def include?(key)
          super(TaliaCore::ActiveSource.expand_uri(key))
        end

        private(:[]=, :store)
      end

      # Special hash that stores one entry per Source. This will expand the URI
      # value for non-db fields to avoid duplicate, semantically identical entries
      class SrcHash < Hash
        
        def initialize(uri)
          assit(uri)
          store(:uri, uri)
        end
        
        def [](key)
          if(TaliaCore::ActiveSource.db_attr?(key))
            super(key)
          else
            key = TaliaCore::ActiveSource.expand_uri(key)
            unless(value = super(key))
              value = store(key, AttrArray.new)
            end
            value
          end
        end
        
        def []=(key, value)
          raise(ArgumentError, "URI should not be reset") if(key.to_sym == :uri)
          raise(ArgumentError, "Only for db element") unless(TaliaCore::ActiveSource.db_attr?(key))
          store(key, value)
        end
        
        def delete(key)
          raise(ArgumentError, "URI should not be reset") if(key.to_sym == :uri)
          key = TaliaCore::ActiveSource.expand_uri(key) unless(TaliaCore::ActiveSource.db_attr?(key))
          super(key)
        end
        
        def include?(key)
          key = TaliaCore::ActiveSource.expand_uri(key) unless(TaliaCore::ActiveSource.db_attr?(key))
          super(key)
        end
        
        def uri
          uri = self[:uri]
          raise(ArgumentError, "No uri on source") unless(uri)
          uri
        end
        
      end
      
      # Array that expands the assigned values into URIs.
      class AttrArray < Array
        
        def <<(value)
          super(value_for(value))
        end
        
        def include?(value)
          super(value_for(value))
        end
        
        def replace(value)
          self.clear
          self << value
        end
        
        private
        
        # If we're passed a source, or URI, we assume that it's a relation
        # to another source. If we're passed an SrcHash, also.
        def value_for(value)
          value = "<#{value.uri.to_s}>" if(value.respond_to?(:uri))
          value
        end
        
      end
      
      def self.hash
        @hash ||= MasterHash.new
      end
      
    end  
  end
end