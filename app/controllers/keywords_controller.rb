class KeywordsController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'keywords/' + params[:id]
    raise(ArgumentError, "Unknow Keyword Source #{element_uri}") unless(TaliaCore::Keyword.exists?(element_uri))
    
    @element = TaliaCore::Keyword.find(element_uri)
    @keys = TaliaCore::Keyword.find(:all)
    val = @element.keyword_value
    @path = [ { :text => 'Keywords', :link => 'keywords/' }, { :text => val } ]
    @title = "Keyword | #{val}"
    @subtitle = "Keyword"
  end

  def index
    @path = [ { :text => 'Keywords'}]
    @keys = TaliaCore::Keyword.find(:all)
    @title = "Keywords"
    @subtitle = "Keywords"
  end
end
