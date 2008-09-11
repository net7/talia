module TaliaCore 
  class CriticalEdition < Catalog
    
    # Prefix for edition URIS
    EDITION_PREFIX = 'critical_editions'
    has_rdf_type N::HYPER.CriticalEdition
    
    # returns an array containing a list of all the books of the given type 
    # (manuscripts, works, etc.) or subtype (notebook, draft, etc.) belonging 
    # to this CRITICAL Edition. Books of a subtype also belong to the type
    # of which it is a subtype.
    # Returns all the books in the catalog. See elements
    def books
      types = [N::TALIA.Book]
      elements_by_type(*types)
    end
    
    def create_book_text_as_contribution
      books_text = []
      books.each do |book|
        book_text = ''
        book.subparts_with_manifestations(N::HYPER.HyperEdition).each do |part|
          part.manifestations(TaliaCore::HyperEdition).each do |manifestation|
            book_text += manifestation.to_html() 
          end
        end
        #TODO: store this as a file somewhere, maybe by creating a new Source and adding it as 
        # it's data?
        books_text << book_text
      end
      books_text
    end
  end
end