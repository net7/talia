require 'yaml'

module TaliaUtil

  module EuropeanaImporter

    class Importer < TaliaCore::ActiveSourceParts::Xml::GenericReader
        
      include EuropeanaReader

      element :bibliographic_description do
        add_default_type 'BibliographicalCard'
        add_mapped :creator
        add_mapped :editor
        add_mapped :title
        add_mapped :alternative
        add_mapped :date
        add_mapped :creation_date
        add_mapped :issued_date
        add_mapped :digital_date
        add_mapped :publisher
        add_mapped :digital_publisher
        add_mapped :provider
        add_mapped :source
        add_mapped :identifier
        add_mapped :europeana_uri
        #add_mapped :is_shown_by
        add_is_shown_by
        add_mapped :is_shown_at
        add_mapped :description
        add_mapped :dc_type
        add_mapped :europeana_type
        add_mapped :dc_language
        add_mapped :europeana_language
        add_mapped :rights
        add_mapped :subject
        add_mapped :has_part
        add_mapped :table_of_contents
        
#        add_mapped :contributor
#        add_mapped :format
#        add_mapped :extent
#        add_mapped :medium
#        add_mapped :dc_relation
#        add_mapped :is_version_of
#        add_mapped :has_version
#        add_mapped :is_replacedb_by
#        add_mapped :replaces
#        add_mapped :is_required_by
#        add_mapped :requires
#        add_mapped :is_part_of
#        add_mapped :is_referenced_by
#        add_mapped :references
#        add_mapped :is_format_of
#        add_mapped :has_format
#        add_mapped :conforms_to
#        add_mapped :coverage
#        add_mapped :spatial
#        add_mapped :temporal
#        add_mapped :provenance
#        add_mapped :user_tag
#        add_mapped :unstored
#        add_mapped :object
#        add_mapped :year
#        add_mapped :hasObject
#        add_mapped :country
        add_defaults
      end

    end
    
  end
end
