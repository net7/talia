module TaliaUtil
  module HyperImporter

    class Importer

      # Helper methods for cloning/handling catalogs.

      private

      # Clone the current source to the given URI. This will either copy the
      # properties of the current element to the clone (if it already exists)
      # or create a fresh clone.
      #
      # It's possible to pass a block to perform some additional operations on
      # the clone.
      def clone_to(clone_uri, source = nil)
        source ||= @source
        catalog = get_catalog()
        clone = SourceCache.cache[clone_uri]
        if(clone)
          source.clone_properties_to(clone, {:catalog => catalog})
          source.make_concordant(clone)
        else
          clone = catalog.add_from_concordant(source)
          SourceCache.cache[clone_uri] = clone
        end
        yield clone if(block_given?)
      end

      # Get the catalog for the currently imported source.
      def get_catalog()
        return @catalog if(defined?(@catalog))

        @catalog = nil
        if(node = @element_xml.elements['catalog'])
          catalog_name = N::LOCAL + node.text.strip if(node.text && node.text.strip != "")
          @catalog = SourceCache.cache.get_or_create(catalog_name, TaliaCore::Catalog)
        end

        @catalog
      end

    end

  end
end
