class CriticalEditionsController < SimpleEditionController
  set_edition_type :critical
  add_javascripts 'tooltip'
  
  def dispatcher
    @request_url = URI::decode(request.url)
    @source = TaliaCore::Source.find(@request_url)
    case @source
    when TaliaCore::Book
      prepare_for_book
    when TaliaCore::Chapter
      prepare_for_chapter
    else
      prepare_for_part
    end
    set_custom_stylesheet ['TEI/p4/tei_style.css', 'tooltip']
    print_tool # Enable the print button
  end
 
  # GET /critical_editions/1
  def show 
    @path = [{:text => params[:id]}]
  end
  
  def print
    set_custom_stylesheet ['TEI/p4/tei_style.css', 'tooltip']
    source_uri = "#{N::LOCAL}#{edition_prefix}/#{params[:id]}/#{params[:part]}"    
    source = TaliaCore::Source.find(source_uri)
    if source.class == TaliaCore::Book
      @book = source 
    else
      @book = source.book
    end
    render :layout => false    
  end
  
  def advanced_search
    # set advanced search widget visible
    set_advanced_search_visible true

    # set default path
    @path = [{:text => params[:id], :link => @edition.uri.to_s}]    
    
    # if user has clicked on seach button, execute search method
    unless params[:advanced_search_submission].nil?
      # check if there are the params
      if (params[:words].nil? or params[:words].strip == "") && 
          (params[:mc].nil? or params[:mc].join.strip == "")
        redirect_to(:back) and return
      end
      
      # execute advanced search
      adv_src = AdvancedSearch.new
      @result = adv_src.search(edition_prefix, params[:id], params[:words], params[:operator], @edition.uri.to_s, params[:mc_from], params[:mc_to], params[:mc_single])
      @result_count = adv_src.size

      @searched_works = []
      unless params[:mc].nil?
        [params[:mc], params[:mc_from], params[:mc_to]].transpose.each do |work,from,to|
          work_item = TaliaCore::Source.find(work)
          from_item = TaliaCore::Source.find(from)
          to_item = TaliaCore::Source.find(to)
          @searched_works << {:work => work_item.title,
            :from => from_item.title || from_item.local_name,
            :to   => to_item.title || to_item.local_name
          }
        end
      end

      # get result for menu
      @exist_result = adv_src.menu_for_search(edition_prefix, params[:id], params[:words], params[:operator], @edition.uri.to_s, params[:mc_from], params[:mc_to])

      # search word
      @words = params[:words]
            
      # get chosen_book for menu
      if params[:mc_single]
        @source = TaliaCore::Source.find(params[:mc_single])
        case @source
        when TaliaCore::Book
          @book = @source
        when TaliaCore::Chapter
          @chapter = @source
          @book = @chapter.book
        else
          @part = @source
          @book = @part.book
          @chapter = @part.chapter
        end
      end
    end
  end
  
  def advanced_search_print
    # set custom stylesheet for screen and print media
    set_custom_edition_stylesheet ['critical_print']
    set_print_stylesheet ['critical_printreal']
    
    @path = []
    
    @result = []

    unless params[:advanced_search_result].nil? || params[:checkbox].nil?
      params[:checkbox].each do |checkbox_id|
        index = checkbox_id.to_i
        @result << {:counter => params[:counter][index], :title => params[:title][index], :description => params[:description][index]}
      end
    end

  end

  private
   
  # Activates the print button
  def print_tool
    @tools = [{:id =>'print', :text=> :'talia.global.print', :target => 'blank', :link => "#{@book.uri.to_s}/print"}]
  end
  
  def prepare_for_book
    @href_for_text = @request_url
    @book = @source
    @path = [
      {:text => params[:id], :link => @edition.uri.to_s}, 
      {:text => @book.dcns.title.first.to_s}        
    ]  
  end
  
  def prepare_for_chapter
    @chapter = @source
    @href_for_text = @chapter.subparts_with_manifestations(N::HYPER.HyperEdition)[0] 
    @book = @chapter.book
    @path = [
      {:text => params[:id], :link => @edition.uri.to_s}, 
      {:text => @book.dcns.title.first.to_s, :link => @book.uri.to_s},
      {:text => @chapter.dcns.title.first.to_s}
    ]
  end
  
  def prepare_for_part
    @part = @source
    @href_for_text = @request_url 
    @book = @part.book
    @chapter = @part.chapter
    @path = [
      {:text => params[:id], :link => @edition.uri.to_s}, 
      {:text => @book.dcns::title.first.to_s, :link => @book.uri.to_s}
    ]
    @path << {:text => @chapter.dcns::title.first.to_s, :link => @chapter.uri.to_s} unless @chapter.nil?
    @path << {:text => @part.dcns::title.empty? ? @part.uri.local_name.to_s : @part.dcns.title.first.to_s}
  end
end
 
 
