=begin
  This is a sample file that explores the possible mechanisms to be used in the
  Source class by giving concrete examples of sources.
  
  This "native" syntax has been drafted to map well to RDFS. Since the Talia partners
  will only suppply RDFS descriptions, more advanced elements are left
  out intentionally.
  
  This describes the ontology/type classes and relation types in the
  system. The objects representing the ontology will be built 
  dynamically at runtime.
  Source class by giving concrete examples of sources.
=end

# The source types map to RDFS class or similiar elements
source_type :Person 

source_type :Author do
  # defines the URI for the type. If nothing is given, the
  # URI defaults to <local_domain>/sourcetype/<name>
  uri "http://something/author"
end

source_type :Essay do
  data_elements :text, :pdf, :structured
end

source_type Path do
  # This maps for example to the "ordered" container type in RDFS
  # However, this will also enable the respective behaviour in 
  # Sources which use this type
  # In general, the subtype_of will work like RDFS subclasses
  # TODO: How will this work?
  subtype_of :Ordered
end

source_type :Work

# The relation types map to RDFS property or similiar types
relation_type :Author do
  # This corresponds to the "range" in RDFS and indicates
  # that this property has the given Source types as objects
  # Note that RDFS semantics are a bit tricky, see also
  # http://jena.sourceforge.net/how-to/rdf-frames.html
  # TODO: Figure out how this is going to work...
  range :Essay, :Work, :Path
  # equivalents? e.g. object :Person ???
  
  # This is the some for the RDFS "domain" statement,
  # which identifies the object classes for the subject(s)
  domain :Person
  # euivalents? e.g. subjects ... ?
  
  # This has no direct RDFS equivalent. It identifies the
  # name to be used for the "inverse" relation. 
  # E.g. the relation is <work> <author> <person>
  # then the inverse relation could be called 
  # <person> <publication> <work>
  # If this is not present, the name will be built
  # as <predicate>_of (e.g. "author_of")
  # TODO: Is this really needed, or is the automatic thing enough.
  # TODO: Check how it's handled in ActiveRDF
  inverse_name :Publication
end

relation_type :Reference do
  range :Work
  
  # If any of range/domain is missing, the relation is always
  # "global", which means that it isn't specific to any source
  # classes.
end

relation_type :Citation do
  # There are also relation subtypes.
  # TODO: How should this work, is this urgently needed?
  subtype_of :Reference
end

class PathRelation < TaliaCore::Relation
  # TODO: Mechanism for sorted relations
end
