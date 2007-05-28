=begin
  This is a sample file that explores the possible mechanisms to be used in the
  Source class by giving concrete examples of sources.
=end

class RelatesAsPerson < TaliaCore::RelatesAs
  # The :any keyword will allow any type. This means
  # that it affects the global superclass instead of a
  # specific type.
  relates_to :any, :observer
end


class Essay < TaliaCore::Source
  # This identifies the "Relationship classes" for this
  # source type.
  # The source class inherits the relations defined there.
  relates_as :work
  relates_as :citeable
  
  has_data_types :text, :pdf, :structured
end

class Path < TaliaCore::Source  
  relates_as :work
  relates_as :citeable
  
  # This class mixes direct relations and 
  # relates_as
  relates_to :part, :path
  relates_to :page, :path
end


class RelatesAsWork < TaliaCore::RelatesAs
  # Multiciplity expressed through pluralization?
  relates_to :person, :author, :mandatory
  relates_to :metatdata, :metadata, :mandatory
  relates_to :citeable, :citation
end

class RelatesAsCiteable < TaliaCore::RelatesAs
  # This statement is optional. If it was missing,
  # the "backlink" would have been inserted
  # automatically.
  relates_from :work, :citation
end




# Relation class: Suffix "Relation" to distinguish from 
# "Author" source class (just an example). 
# For the functions used in the examples above, this
# suffix will automatically be added
class AuthorRelation < TaliaCore::Relation
  # This defines the accessor name and cardinality for the
  # start and end points
  startpoint :multiple, :accessor => "authors"
  endpoint :multiple, :accessor => "works"
  
  add_to_startpoint :primary_author do
    find(XXX)
  end
end

class PathRelation < TaliaCore::Relation
  # TODO: Mechanism for sorted relations
end
