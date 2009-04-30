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
        clone
      end

      # Get the catalog for the currently imported source.
      def get_catalog()
        return @catalog if(defined?(@catalog))

        @catalog = nil
        catalog_name = get_text(@element_xml, 'catalog')
        @catalog = get_source_with_class(catalog_name, TaliaCore::Catalog) if(catalog_name)

        @catalog
      end

    end

  end
end
