class CriticalEditionsController < SimpleEditionController
  set_edition_type :critical
  
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
  end
  
  # GET /critical_editions/1
  def show 
    @path = [{:text => params[:id]}]
  end
  
  def advanced_search
    # if user has clicked on seach button, execute search method
    unless params[:advanced_search_submission].nil?
      # collect data to post
      data = {
        'search_type' => params[:search_type],
        'operator' => params[:operator]
      }
      
      # check if words field is empty 
      if params[:words]
        data['words'] = params[:words]
      end
      
      # add mc - mc_from - mc_to if specified
      if params[:mc]
        data['mc[]'] = params[:mc]
        data['mc_from[]'] = params[:mc_from]
        data['mc_to[]'] = params[:mc_to]
      end

      # add mc_single if specified
      if params[:mc_single]
       data['mc_single'] = (params[:mc_single])
      end
      
      # execute post to servlet
      resp = Net::HTTP.post_form URI.parse("http://gandalf.aksis.uib.no:8080/nietzsche/Search"), data
      
      # error check
      raise "#{resp.code}: #{resp.message}" unless resp.kind_of?(Net::HTTPSuccess)
     
      # get response xml document
      doc = REXML::Document.new resp.body
      
      # total item
      @result_count = doc.root.attribute('total').value
      # search word
      @words = params[:words]
      
      # get level 2 group
      groups = doc.get_elements('/*/*/*/talia:group/talia:entry')
      # collect result. It create an array of hash {title, description}
      @result = groups.collect do |item|
        {:title => item.elements['talia:metadata/talia:standard_title'].text, :description => item.elements['talia:excerpt'].children.to_s}
      end
      
      @exist_result = doc.get_elements('/talia:result/talia:group')
      
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

  private
  
  def prepare_for_book
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
 
 
