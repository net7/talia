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

  before_filter :setup_tools
  caches_action :show, :books, :panorama, :page, :double_pages, :locale => :current_locale

  # GET /facsimile_editions/1
  def show
    set_custom_stylesheet ['front_page']
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
    @page_title_suff = ", #{t_type.titleize}"
    
    @path = [
      {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"}
    ]
    if(@subtype)
      @path << { :text => t_type, :link => link_for_type }
      @path << { :text => t_subtype }
    else
      @path << { :text => t_type }
    end
  end
  
  # GET /facsimile_editions/1/1
  # 
  # GET /facsimile_editions/1/1.jpeg
  # GET /facsimile_editions/1/1.jpeg?size=thumbnail
   
  def panorama
    respond_to do |format|
      format.html do
        @book = TaliaCore::Book.find(URI::decode(request.url))
        @type = @book.material_type.local_name
        @subtype = @book.material_subtype.local_name
        @path = [
          {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"},
          {:text => t_type, :link => link_for_type},
          {:text => t_subtype, :link => link_for_subtype},
          {:text => params[:book] }
        ]
        pdf_tool(@book)
        @page_title_suff = ", #{params[:book]}"
      end
      format.jpeg do
        #        book_uri = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:book]
        #TODO it should return the whole book in PDF format (?)
      end
    end
  end


  # GET /fasimile_editions/1/1/2
  def double_pages
    # we need to show the large images of both pages
    @double_pages = true
    page = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page]
    page2 = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page2]
    @page = TaliaCore::Page.find(page)
    @page2 = TaliaCore::Page.find(page2)

    setup_vars_for_pages!

    @page2_facsimile = facsimile_for(@page2)
    
    @page_title_suff = ", #{params[:page]}"
    @page_title_suff += "- #{params[:page2]}"
    render :action=> 'page'
  end

  # TODO DRYup w/ panorama
  # GET /facsimile_editions/1,1
  # 
  # GET /facsimile_editions/1,1.jpeg
  # GET /facsimile_editions/1,1.jpeg?size=thumbnail
  def page
    respond_to do |format|
      format.html do
        @page = TaliaCore::Page.find(URI::decode(request.url))
        download_tool(@page)
        # Cache the facsimile

        setup_vars_for_pages!
        
        @page_title_suff = ", #{params[:page]}"
      end
      format.jpeg do
        page_uri = "#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page]
        page = TaliaCore::Page.find("#{N::LOCAL}#{edition_prefix}" + '/' + params[:id] + '/' + params[:page])
        facsimile = page.manifestations(TaliaCore::Facsimile)[0]
        send_file facsimile.original_image.file_path, :type => 'image/jpeg', :filename => page.uri.local_name.to_s + '.jpeg', :disposition => 'attachment'
      end
    end
  end
  
  def search
    sanitizer = HTML::FullSanitizer.new
    searched_book = sanitizer.sanitize(params[:book]) unless params[:book].empty?
    searched_page = sanitizer.sanitize(params[:page]) unless params[:page].empty?
    search_result = @edition.search(searched_book, searched_page)
    redirect_to search_result[0].uri.to_s and return unless (search_result.empty?)
    flash[:search_notice] = t(:'talia.search.records_not_found')
    redirect_to(:back) and return
  end
  
  private
  
  def setup_vars_for_pages!
    qry = Query.new(TaliaCore::Book).select(:b).distinct
    qry.where(@page, N::DCT.isPartOf, :b)
    result=qry.execute
    @book = result[0]
    @type = @book.material_type.local_name
    @subtype = @book.material_subtype.local_name
    @path = page_path
    @page_facsimile = facsimile_for(@page)
  end
  
  def t_type
    t(:"talia.types.#{@type.underscore}")
  end
  
  def t_subtype
    t(:"talia.types.#{@subtype.underscore}")
  end
  
  def link_for_type
    "#{N::LOCAL}#{edition_prefix}/#{params[:id]}/#{@type}"
  end
  
  def link_for_subtype
    link_for_type + "/#{@subtype}"
  end
  
  # Activates the print button
  def print_tool
    #TODO: PDF integration. the next line should add a call to the pdf.
    # @tools  << { :id => 'print', :text => :'talia.global.print', :link => '#TODO: PDF creation' }
    # @tools << { :id => 'download', :text => 'download', :link => '#TODO: PDF creation'}
    # @tools << { :id => 'fullscreen', :text => 'fullscreen', :link => '#TODO: PDF creation'}
  end

  # Activates the fullscreen button
  def fullscreen_tool
    @tools << { :id => 'fullscreen', :text => 'talia.global.fullscreen', :link => ''}
  end


  # Activates original image download button
  def download_tool(element)
    return unless(element)
    @tools << { :id => 'download', :text => 'download', :link => element.to_s + '.jpeg' }
  end

  # Activates pdf download button
  def pdf_tool(element)
    return unless(element)
    pdf_data = element.data_records.find(:first, :conditions => { :type => 'PdfData' } )
    if(pdf_data)
      @tools << { :id => 'download', :text => 'download', :link => data_link(pdf_data) }
    end
  end

  # Makes the path for the page
  def page_path
    path =[
      {:text => params[:id], :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}"},
      {:text => t_type, :link => link_for_type},
      {:text => t_subtype, :link => link_for_subtype},
      {:text => (@book.siglum || @book.uri.local_name), :link => "#{N::LOCAL}#{edition_prefix}" + "/#{params[:id]}/#{@book.uri.local_name}"}
    ]
    text = params[:page]
    if (params[:page2])
      text << " | #{params[:page2]}"
    end
    path << {:text => text}
    path
  end

  def setup_tools
    @tools = []
  end

  def facsimile_for(page)
    page.manifestations(TaliaCore::Facsimile).first
  end

  def data_link(data)
    static_prefix = TaliaCore::CONFIG['static_data_prefix']
    if(!static_prefix || static_prefix == '' || static_prefix == 'disabled')
      url_for(:controller => 'source_data', :action => 'show', :id => data.id)
    else
      data.static_path
    end
  end

end
