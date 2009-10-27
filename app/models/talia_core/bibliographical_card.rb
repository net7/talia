module TaliaCore

  class BibliographicalCard < ExpressionCard

    singular_property :alternative, N::DCT.alternative
    singular_property :creator, N::DCNS.creator
    singular_property :subject, N::DCNS.creator
    singular_property :description, N::DCNS.description
    singular_property :table_of_contents, N::DCT.tableOfContents
    singular_property :publisher, N::DCNS.publisher
    singular_property :contributor, N::DCNS.contributor
    singular_property :date, N::DCNS.date
    singular_property :created, N::DCT.created
    singular_property :issued, N::DCT.issued
    singular_property :dc_type, N::DCNS.type
    singular_property :format, N::DCNS.format
    singular_property :extent, N::DCT.extent
    singular_property :medium, N::DCT.medium
    singular_property :identifier, N::DCNS.identifier
    singular_property :source, N::DCNS.source
    singular_property :language, N::DCNS.language
    singular_property :relation, N::DCNS.relation
    singular_property :is_version_of, N::DCT.isVersionOf
    singular_property :has_version, N::DCT.hasVersion
    singular_property :is_replaced_by, N::DCT.isReplacedBy
    singular_property :replaces, N::DCT.replaces
    singular_property :is_required_by, N::DCT.isRequiredBy
    singular_property :requires, N::DCT.requires
    singular_property :is_part_of, N::DCT.isPartOf
    singular_property :has_part, N::DCT.hasPart
    singular_property :is_referenced_by, N::DCT.isReferencedBy
    singular_property :references, N::DCT.references
    singular_property :is_format_of, N::DCT.isFormatOf
    singular_property :has_format, N::DCT.hasFormat
    singular_property :conforms_to, N::DCT.conformsTo
    singular_property :is_shown_by, N::HYPER.isShownBy
    singular_property :is_shown_at, N::HYPER.isShownAt
    singular_property :coverage, N::DCNS.coverage
    singular_property :spatial, N::DCT.spatial
    singular_property :temporal, N::DCT.temporal
    singular_property :rights, N::DCNS.right
    singular_property :provenance, N::DCT.provenance
    singular_property :user_tag, N::HYPER.userTag
    singular_property :unstored, N::HYPER.unstored
    singular_property :object, N::HYPER.object
    singular_property :language, N::HYPER.language
    singular_property :provider, N::HYPER.provider
    singular_property :europeana_type, N::HYPER.type
    singular_property :europeana_uri, N::HYPER.uri
    singular_property :year, N::HYPER.year
    singular_property :has_object, N::HYPER.hasObject
    singular_property :country, N::HYPER.country






  end

end