class SeriesController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'series/' + params[:id]
    raise(ArgumentError, "Unknow Series #{element_uri}") unless(TaliaCore::Series.exists?(element_uri))
    
    @element = TaliaCore::Series.find(element_uri)
    @path = [ { :text => 'Series', :link => 'series/' }, { :text => @element.hyper::name.first } ]
    @title = t(:'talia.global.series') + " | #{@element.hyper::name.first }"
    @subtitle = t(:'talia.global.series')
  end

  def index
    @path = [ { :text => 'Series' }]
    @series = TaliaCore::Series.find(:all)
    @title = t(:'talia.global.series')
    @subtitle = t(:'talia.global.series')
  end
  
  def advanced_search
    @advanced_search_visible = true
    @path = []
    
    # if user has clicked on seach button, execute search method
    unless params[:advanced_search_submission].nil?
      # check if there are the params
      if (params[:title_words].nil? or params[:title_words].join.strip == "") && 
         (params[:abstract_words].nil? or params[:abstract_words].join.strip == "") && 
         (params[:keyword].nil? or params[:keyword].join.strip == "")
        redirect_to(:back) and return
      end
      
      # execute advanced search
      @result = AdvancedSearch.new.av_search(params[:title_words],params[:abstract_words],params[:keyword])
      @result_count = @result.size     
    end
  end
  
end
