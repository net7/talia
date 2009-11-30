module TaliaCore

  class BibliographicalCard < Source

    singular_property :creator, N::DCNS.creator
    singular_property :alternative, N::DCT.alternative
    singular_property :created, N::DCT.created
    singular_property :publisher, N::DCNS.publisher
    singular_property :digital_publisher, N::HYPER.digital_publisher
    singular_property :provider, N::HYPER.provider
    singular_property :source, N::DCNS.source
    singular_property :identifier, N::DCNS.identifier
    singular_property :europeana_uri, N::HYPER.uri
    singular_property :is_shown_by, N::HYPER.isShownBy
    singular_property :is_shown_at, N::HYPER.isShownAt
    singular_property :dc_type, N::DCNS.type
    singular_property :europeana_type, N::HYPER.type
    singular_property :language, N::DCNS.language
    singular_property :europeana_language, N::HYPER.language
    singular_property :rights, N::DCNS.right
    singular_property :table_of_contents, N::DCT.tableOfContents
    
#    singular_property :contributor, N::DCNS.contributor
#    singular_property :format, N::DCNS.format
#    singular_property :extent, N::DCT.extent
#    singular_property :medium, N::DCT.medium
#    singular_property :relation, N::DCNS.relation
#    singular_property :is_version_of, N::DCT.isVersionOf
#    singular_property :has_version, N::DCT.hasVersion
#    singular_property :is_replaced_by, N::DCT.isReplacedBy
#    singular_property :replaces, N::DCT.replaces
#    singular_property :is_required_by, N::DCT.isRequiredBy
#    singular_property :requires, N::DCT.requires
#    singular_property :is_referenced_by, N::DCT.isReferencedBy
#    singular_property :references, N::DCT.references
#    singular_property :is_format_of, N::DCT.isFormatOf
#    singular_property :has_format, N::DCT.hasFormat
#    singular_property :conforms_to, N::DCT.conformsTo
#    singular_property :coverage, N::DCNS.coverage
#    singular_property :spatial, N::DCT.spatial
#    singular_property :temporal, N::DCT.temporal
#    singular_property :provenance, N::DCT.provenance
#    singular_property :user_tag, N::HYPER.userTag
#    singular_property :unstored, N::HYPER.unstored
#    singular_property :object, N::HYPER.object
#    singular_property :year, N::HYPER.year
#    singular_property :has_object, N::HYPER.hasObject
#    singular_property :country, N::HYPER.country

    def editor(value=nil)
      if value.nil?
        self.hyper::editor
      else
        self.hyper::editor = value
      end
    end

    def title(value=nil)
      if value.nil?
        self.dcns::title
      else
        self.dcns::title = value
      end
    end

    def date(value=nil)
      if value.nil?
        self.dcns::date
      else
        self.dcns::date = value
      end
    end

    def issued(value=nil)
      if value.nil?
        self.dct::issued
      else
        self.dct::issued = value
      end
    end

    def digital_date(value=nil)
      if value.nil?
        self.hyper::digital_date
      else
        self.hyper::digital_date = value
      end
    end
    
    def is_part_of(value=nil)
      if value.nil?
        self.dct::is_part_of
      else
        self.dct::is_part_of = value
      end
    end

    def description(value=nil)
      if value.nil?
        self.dcns::description
      else
        self.dcns::description = value
      end
    end

    def subject(value=nil)
      if value.nil?
        self.dcns::subject
      else
        self.dcns::subject = value
      end
    end

    def has_part(value=nil)
      if value.nil?
        self.dct::has_part
      else
        self.dct::has_part = value
      end
    end
  end

end