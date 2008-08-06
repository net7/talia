class CriticalEditionsController < ApplicationController
  #  before_filter :find_critical_edition
  
  # GET /critical_editions/1
  def show  
 
    @result = []
    fe = TaliaCore::FacsimileEdition.find(N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/DEF')
    qry = Query.new(TaliaCore::Book).select(:b).distinct
    qry.where(:b, N::RDF.type, N::HYPER.Book)
    qry.where(:p, N::HYPER.part_of, :b)
    #    qry.where(:f, N::HYPER.manifestation_of, :p)
    #TODO: for testing I'm using N::HYPER.cites 
    # remove it and uncomment the above line when it works 
    qry.where(:f, N::HYPER.cites, :p)
    qry.where(:f, N::RDF.type, N::HYPER.Facsimile)
    qry.where(:f, N::RDF.type, N::HYPER.Color)
    qry.execute.each do |book| 
      #      fe.add_from_concordant(book, true) 
      book.pages.each do |page|
#        fe_page = TaliaCore::Page.find(fe.uri + '/' + page.siglum)
        qry = Query.new(TaliaCore::Facsimile).select(:f).distinct.limit(1)
        #    qry.where(:f, N::HYPER.manifestation_of, page)
        #TODO: for testing I'm using N::HYPER.cites 
        # remove it and uncomment the above line when it works 
        qry.where(:f, N::HYPER.cites, page)       
        qry.where(:f, N::RDF.type, N::HYPER.Facsimile)
        qry.where(:f, N::RDF.type, N::HYPER.Color)
        @result[] << qry.execute[0]

        #        fe_page.add_manifestation(qry.execute[0])
      end
    end
    return
    f = TaliaCore::Facsimile.find('egrepalysviola-1')
    if (f.is_a?(TaliaCore::Manifestation))
      @result = " e' manifestation"
    else
      @result = " non lo e'"
    end
    return
    #TODO: load all the books and create the left menu
    # the right zone of the web page will contain the description/some info
    @menu_items = []
    @books = @critical_edition.books
    @books.each do |book|
      @menu_items << {:uri => book, :title => TaliaCore.Book.find(book).dcns::title}
    end
  end
  
  private
  def find_critical_edition
    @critical_edition = TaliaCore::CriticalEdition.find("#{N::LOCAL}#{params[:id]}")
  end
end
 
 