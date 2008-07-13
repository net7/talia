module TaliaCore 
  class FacsimileEdition < MacroContribution
    def initialize(uri, *types)
      super(uri, *types)
      # TODO: 'Facsimile' should actually be a valid value in the ontology
      self.macrocontribution_type = 'Facsimile'
    end
    
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
      #TODO: everything
      result = ['N-IV-1', 'N-IV-2', 'N-IV-3', 'N-IV-4']
    end
    
    # returns all the pages of the given book contained in this Facsimile Edition 
    def related_pages(book)
      #TODO: everything
      result =  ['N-IV-2,1','N-IV-2,2','N-IV-2,3', 'N-IV-2,4']
    end
    
    # returns the description of the book given as parameter, taken from the "material description" contribution
    # which is supposed to be related to this Facsimile Edition
    def material_description(book)
      #TODO: everything
      result = "#{book} description"
    end

    # searches for the facsimile related to the page passed as a parameter
    # which also belongs to the facsimile edition we're in.
    # It then returns the first TaliaCore::ImageData object of it
    def page_image_data(book, page, size)
      #TODO: everything
      case size
      when 'thumbnail'
        fax = Source.find('egrepalysviola-1441')
        fax.data('ImageData')[0]
      else
        fax = Source.find('egrepalysviola-1439')
        fax.data('ImageData')[0]
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
    
    
    # returns the copyright note of the facsimile related to the given page
    # the copyright note is related to the archive where the material is kept
    def copyright_note(page)
      #TODO:everything
      'copyright note'
    end
    

    def search(requested_book='', requested_page='')
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
          book = Source.find(requested_book) || nil
#          this was used toghether with a different way of creating the redirection.
#          please look at facsimile_editions_controller.rb 
#          result = {:book => "#{book.id}"}
          
          result = [book.id]
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
          book = Source.find(requested_book)
          qry1 = RdfQuery.new(:EXPRESSION, N::HYPER::part_of, book)
          qry2 = RdfQuery.new(:EXPRESSION, N::HYPER::position_name, requested_page)
          #TODO: check that the page is in the facsimile edition 
          qry = RdfQuery.new(:AND, qry1, qry2)
          page = qry.execute[0]
#          this was used toghether with a different way of creating the redirection.
#          please look at facsimile_editions_controller.rb 
#          result = {:book => "#{book.id}", :page => "#{page.id}"}
           
          result = [book.id, page.id]
        end
      end
      result
    end
  
    # returns the left or right "neighbour" source of the given source.
    # movement is expected in the form of "next" or "previous"
    # used, for instance, for browsing pages
    def neighbour_source(source, movement)
      #TODO: everything
      result = 'N-IV-2,3'
    end
    
  end
end