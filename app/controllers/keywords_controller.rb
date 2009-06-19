class KeywordsController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'keywords/' + params[:id]

    @element = TaliaCore::Keyword.find(element_uri)
    @keys = TaliaCore::Keyword.find(:all)
    val = t(:"talia.keywords.#{@element.keyword_value}")
    @path = [ { :text => t(:'talia.global.keyword'), :link => '/keywords/' }, { :text => val } ]
    @title = t(:'talia.global.keyword') + " | #{val}"
    @subtitle = t(:'talia.global.keyword')
  end

  def index
    @path = [ { :text => 'Keywords'}]
    @keys = TaliaCore::Keyword.find(:all)
    @title = t(:'talia.global.keywords')
    @subtitle = t(:'talia.global.keywords')
  end
end
