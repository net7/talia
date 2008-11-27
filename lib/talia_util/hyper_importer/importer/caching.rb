module TaliaUtil
  module HyperImporter

      class Importer

        # Helper methods for caching.
        module CachingClassMethods
          # Cache for type objects to avoid lookups in the type wrapper itself
          def type_cache
            @type_cache ||= {}
          end

          # Retrieve a type from the type cache
          def type_cache_retrieve(value)
            value = value.uri
            if(cached = type_cache[value])
              cached
            else
              src = TaliaCore::ActiveSource.find(:first, :conditions => { :uri => value } )
              src ||= TaliaCore::ActiveSource.new(value) # Create new type if there's none
              type_cache[value] = src
              src
            end
          end
        end

        extend CachingClassMethods

      end

  end
end
