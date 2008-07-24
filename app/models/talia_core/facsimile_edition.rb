module TaliaCore 
  class FacsimileEdition < Catalog
   # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
    def types
      #TODO: everything
      result = ['works', 'manuscripts', 'library', 'correspondence', 'picture']
    end
    
    # returns an array containing a list of available subtypes of the given type. Of course they must
    # be present in the facsimile edition we're in
    def subtypes(type)
      #TODO: everything
      result = ['copybooks', 'notebooks', 'drafts']
    end
    
    # returns an array containing a list of all the books of the given type (manuscripts, works, etc.) 
    # and subtype (notebook, draft, etc.) belonging to this Facsimile Edition
    def books(type, subtype = nil)
      if(subtype)
        Book.find(:all, :type => subtype)
      else
        Book.find(:all, :type => type)
      end
    end

    # Starting from the book URI, it searches for the first of its pages belonging to the
    # facsimile edition we're in and calls page_image to do the rest
    def book_image_data(book, size)
      #TODO: everything
      #TODO: retrieve the first page being part of this facsimile edition from RDF
      page = 'some magic tricks will fill this'
      page_image_data(book, page, size)
    end
    
    def search(requested_book='', requested_page='')
      # TODO: Rewrite on RDF queries...
      
      result = ''
      case requested_page
      when ''
        case requested_book
        when ''
          #nothing was requested, nothing should be returned
          raise ActiveRecord::RecordNotFound
        else
          # the book name has been passed, but we haven't the page name
          # we redirect to the "page" action of the first page of the book
          book = Source.find(N::LOCAL + "#{requested_book}") || nil
          #          this was used toghether with a different way of creating the redirection.
          #          please look at facsimile_editions_controller.rb 
          #          result = {:book => "#{book.id}"}
          
          result = [book.uri.local_name]
          #TODO: check that the book is part of the facsimile edition we're in
        end
      else 
        # requested_page is not nil
        case requested_book
        when ''
          #TODO: we said this case is senseless, we'll deal with it as if it was
          # an error, but we should show a nice message
          raise ActiveRecord::RecordNotFound
        else
          # both the book name and the page name were given, we redirect 
          # the user right there, in the "page" action of it          
          book = Source.find(N::LOCAL + "#{requested_book}")
          #TODO: it stopped working after the new backend creation
          qry1 = TaliaCore::RdfQuery.new(:EXPRESSION, N::HYPER::part_of, book)
          qry2 = TaliaCore::RdfQuery.new(:EXPRESSION, N::HYPER::position_name, requested_page)
          #TODO: check that the page is in the facsimile edition 
          qry = TaliaCore::RdfQuery.new(:AND, qry1, qry2)
          page = qry.execute[0]
          #          this was used toghether with a different way of creating the redirection.
          #          please look at facsimile_editions_controller.rb 
          #          result = {:book => "#{book.id}", :page => "#{page.id}"}
           
          result = [book.uri.local_name, page.uri.local_name]
        end
      end
      result
    end
  
    # returns the left or right "neighbour" source of the given source.
    # movement is expected in the form of "next" or "previous"
    # used, for instance, for browsing pages
    def neighbour_source(source, movement)
      #TODO: Move to "Page"
      result = 'N-IV-2,3'
    end
    
  end
end