class FacsimileEditionsController < ApplicationController
  before_filter :find_facsimile_edition
 
  # GET /facsimile_editions/1
  def show
  end

  # GET /facsimile_editions/1/works
  # GET /facsimile_editions/1/manuscripts
  # GET /facsimile_editions/1/library
  # GET /facsimile_editions/1/correspondence
  # GET /facsimile_editions/1/pictures
  #
  # GET /facsimile_editions/1/manuscripts/copybooks
  def books
    if (params[:subtype])
      type = N::SourceClass.new(N::HYPER + params[:subtype])
    else
      type = @facsimile_edition.book_subtypes(N::HYPER + params[:type])[0]
    end
    @books = @facsimile_edition.books(type)
    @type = params[:type]
    @subtype = params[:subtype]
  end
  
  # GET /facsimile_editions/1/1
  # 
  # GET /facsimile_editions/1/1.jpeg
  # GET /facsimile_editions/1/1.jpeg?size=thumbnail
   
  def panorama
    respond_to do |format|
      format.html do
        @book = TaliaCore::Book.find(request.url)
        @type = @book.type.uri.local_name
      end
      format.jpeg do
        book_uri = N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/' + params[:id] + '/' + params[:book]
        qry = Query.new(TaliaCore::Source).select(:f).distinct.limit(1)
        qry.where(:p, N::HYPER.part_of, book_uri)
        qry.where(:f, N::HYPER.manifestation_of, :p)
        qry.where(:p, N::HYPER.position, :pos)
        qry.sort(:pos)
        facsimile = qry.execute[0]
        return facsimile.iip_path unless (params[:size] == 'thumbnail')
        return url_for(:controller => 'source_data', :id => facsimile.id)
      end
    end
  end
    
  # TODO DRYup w/ panorama
  # GET /facsimile_editions/1,1
  # 
  # GET /facsimile_editions/1,1.jpeg
  # GET /facsimile_editions/1,1.jpeg?size=thumbnail
  def page
    respond_to do |format|
      format.html do
        # if a 'pages' params with 'double' as a value and a 'page2' param with
        # the siglum of a page have been passed, we need to show the large images of both pages 
        if (params[:pages] == 'double')
          page = N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/' + params[:id] + '/' + params[:page]
          page2 = N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/' + params[:id] + '/' + params[:page2]  
          @page = TaliaCore::Page.find(page)
          @page2 = TaliaCore::Page.find(page2)
        else
          @page = TaliaCore::Page.find(request.url)
        end         
        qry = Query.new(TaliaCore::Book).select(:b).distinct
        qry.where(@page, N::HYPER.part_of, :b)
        result=qry.execute
        @book = result[0]
        @type = @book.type.uri.local_name
      end
      format.jpeg do
        page = N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/' + params[:id] + '/' + params[:page]
        facsimile = TaliaCore::Page.find(N::LOCAL + TaliaCore::FacsimileEdition::EDITION_PREFIX + '/' + params[:id] + '/' + params[:page]).manifestations(TaliaCore::Facsimile)
        facsimile.iip_path
        return facsimile.iip_path unless (params[:size] == 'thumbnail')
        return facsimile.thumb
      end
    end
  end

  
  def search 
    searched_book = sanitize(params[:book]) unless params[:book].empty?
    searched_page = sanitize(params[:page]) unless params[:page].empty?
    search_result = @facsimile_edition.search(searched_book, searched_page)
    redirect_to search_result[0].uri.to_s and return unless (search_result.empty?)
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back) and return
  end
  
  private
  def find_facsimile_edition
    edition = "#{N::LOCAL}#{TaliaCore::FacsimileEdition::EDITION_PREFIX}/#{params[:id]}" 
    @facsimile_edition = TaliaCore::FacsimileEdition.find(edition)
  end
end
