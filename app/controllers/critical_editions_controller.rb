class CriticalEditionsController < ApplicationController
  before_filter :find_critical_edition
  
  def dispatcher
    require 'cgi'
    @request_url = CGI::unescape(request.url)
    @source = TaliaCore::Source.find(@request_url)
    case @source
    when TaliaCore::Book
      send("render_book")
    when TaliaCore::Chapter
      send("render_chapter")
    else
      send("render_part")
    end
  end
  
  # GET /critical_editions/1
  def show  
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

  def find_critical_edition
    edition = "#{N::LOCAL}#{TaliaCore::CriticalEdition::EDITION_PREFIX}/#{params[:id]}"
    @critical_edition = TaliaCore::CriticalEdition.find(edition)
  end
  
  def render_book
    @book = @source
    render :template => 'critical_editions/book'    
  end
  
  def render_chapter
    @chapter = @source
    @href_for_text = @chapter.subparts_with_manifestations(N::HYPER.HyperEdition)[0] 
    @book = @chapter.book
    render :template => 'critical_editions/chapter'
  end
  
  def render_part
    @part = @source
    @href_for_text = @request_url 
    @book = @part.book
    @chapter = @part.chapter
    render :template => 'critical_editions/part'
  end
end
 
 
