=begin
  This is a sample file that explores the possible mechanisms to be used in the
  Source class by giving concrete examples of sources
=end


class Essay < TaliaCore::Source
  # This identifies the "Relationship classes" for this
  # source type. These classes define allowed relationships
  # for a group of sources.
  relates_as :work
  relates_as :citeable
  
  has_data_types :text, :pdf, :structured
end

class Path < TaliaCore::Source
  # Additional behaviour mixed in. All arguments after
  # the first will be passed on to the function.
  behaves_as :sorted_relation_list
  
  relates_as :work
  relates_as :citeable
  relates_as :path
end


class RelatesAsWork < TaliaCore::RelatesAs
  # Multiciplity expressed through pluralization?
  relates_to :person, :author, :mandatory
  relates_to :metatdata, :metadata, :mandatory
  relates_to :citeable, :citation
end

class RelatesAsCiteable < TaliaCore::RelatesAs
  # Nothing here, "backlink" is automatic
end

class RelatesAsPerson < TaliaCore::RelatesAs
  # The :any keyword will allow any type. This means
  # that it affects the global superclass instead of a
  # specific type.
  relates_to :any, :observer
end

class RelatesAsMetadata < TaliaCore::RelatesAs
  # This is just a placeholder class, since Metadata
  # objects do not have outgoing relations
end

class RelatesAsPath < TaliaCore::RelatesAs
  relates_to :part, :path
  relates_to :page, :path
end



# Relation class: Suffix "Relation" to distinguish from 
# "Author" source class (just an example). 
# For the functions used in the examples above, this
# suffix will automatically be added
class AuthorRelation < TaliaCore::Relation
  # This adds an accessor to the Source where the
  # Relation starts from (in this case, the work)
  # Unless specified, this will add both "authors",
  # which returns a list of all authors, and "author"
  # which returns a sigle author.
  startpoint_accessor :author
  # This adds an accessor to the Source where the
  # Relation ends (in this case, the author)
  endpoint_accessor :work
  
  add_to_startpoint :primary_author do
    find(XXX)
  end
end

class PathRelation < TaliaCore::Relation
  
end