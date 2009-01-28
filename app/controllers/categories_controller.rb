class CategoriesController < ApplicationController

  layout 'simple_page'

  # GET /categories
  def index
    redirect_to root_url
  end
  
  def show
    cat_uri = N::LOCAL + request.request_uri[1..-1]
    raise(ArgumentError, "Unknow Category #{cat_uri}") unless(TaliaCore::Category.exists?(cat_uri))
    
    @category = TaliaCore::Category.find(cat_uri)
    @all_categories = TaliaCore::Category.find(:all)
    @path = [ { :text => t(@category.name) } ]
    @title = t(:'talia.global.category') + " | #{t(@category.name)}"
    @subtitle = t(:'talia.global.category') 
  end
  
  def advanced_search
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
