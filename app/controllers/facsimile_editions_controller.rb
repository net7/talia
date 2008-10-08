# 
# Variables set for the template:
#
# @edition - the currently active edition
# @page_title_suff - a suffix that will be appended to the page title
# @path - an array of elements that will be used for the "breadcrumb path"
# @tools - an array of elements that will be used for the "toolbar icons"
#
class FacsimileEditionsController < SimpleEditionController
  set_edition_type :facsimile
  add_javascripts 'swfobject', 'iip_flashclient'
    
    # GET /facsimile_editions/1
  def show
    @path = [{:text => params[:id]}]
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
      type = @edition.book_subtypes(N::HYPER + params[:type])[0]
    end
    @books = @edition.books(type)
    @type = params[:type]
    @subtype = params[:subtype]
    @page_title_suff = ", #{params[:type].pluralize.t.titleize}"
    @path = [
      {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"},
      {:text => @type.capitalize.pluralize.t}
    ]
  end
  
  # GET /facsimile_editions/1/1
  # 
  # GET /facsimile_editions/1/1.jpeg
  # GET /facsimile_editions/1/1.jpeg?size=thumbnail
   
  def panorama
    respond_to do |format|
      format.html do
        @book = TaliaCore::Book.find(URI::decode(request.url))
        @type = @book.type.uri.local_name
        @path = [
          {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"},
          {:text => @type.capitalize.pluralize.t, :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}/#{@type}"},
          {:text => params[:book] + ' (panorama)'}
        ]
        print_tool # Enable the print button
        @page_title_suff = ", #{params[:book].t}"
      end
      format.jpeg do
        book_uri = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:book]
        qry = Query.new(TaliaCore::Source).select(:f).distinct.limit(1)
        qry.where(:p, N::HYPER.part_of, book_uri)
        qry.where(:p, N::RDF.type, N::HYPER.Page)
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
          page = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page]
          page2 = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page2]  
          @page = TaliaCore::Page.find(page)
          @page2 = TaliaCore::Page.find(page2)
        else
          @page = TaliaCore::Page.find(URI::decode(request.url))
        end         
        qry = Query.new(TaliaCore::Book).select(:b).distinct
        qry.where(@page, N::HYPER.part_of, :b)
        result=qry.execute
        @book = result[0]
        @type = @book.type.uri.local_name
        @path = page_path
        @page_title_suff = ", #{params[:page].t}"
        @page_title_suff += "- #{params[:page2].t}" if(params[:page2])
        print_tool # Enable the print button
      end
      format.jpeg do
        page = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page]
        facsimile = TaliaCore::Page.find("#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page]).manifestations(TaliaCore::Facsimile)
        facsimile.iip_path
        return facsimile.iip_path unless (params[:size] == 'thumbnail')
        return facsimile.thumb
      end
    end
  end
  
  def search 
    searched_book = sanitize(params[:book]) unless params[:book].empty?
    searched_page = sanitize(params[:page]) unless params[:page].empty?
    search_result = @edition.search(searched_book, searched_page)
    redirect_to search_result[0].uri.to_s and return unless (search_result.empty?)
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back) and return
  end
  
  private
  
  # Activates the print button
  def print_tool
    @tools = [['print', 'Print']]
  end
  
  # Makes the path for the page
  def page_path
    path =[
      {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"},
      {:text => @type.capitalize.pluralize.t, :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}/#{@type}"},
      {:text => @book.uri.local_name + ' (panorama)', :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}/#{@book.uri.local_name}"}
    ]
    text = params[:page]
    if (params[:page2])
      text << " | #{params[:page2]}"
    end
    path << {:text => text}
    path
  end

end
