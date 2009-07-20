module TaliaUtil

  module HyperImporter

    # Import class for catalogs
    class CatalogImporter < Importer

      source_type 'hyper:Catalog'
      title_required false

      def import!
        add_property_from(@element_xml, 'position')
      end

    end
  end
end