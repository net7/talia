class SeriesController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'series/' + params[:id]
    raise(ArgumentError, "Unknow Series #{element_uri}") unless(TaliaCore::Series.exists?(element_uri))
    
    @element = TaliaCore::Series.find(element_uri)
    @path = [ { :text => 'Series', :link => 'series/' }, { :text => @element.hyper::name.first } ]
    @title = "Series | #{@element.hyper::name.first }"
    @subtitle = "Series"
  end

  def index
    @path = [ { :text => 'Series' }]
    @series = TaliaCore::Series.find(:all)
    @title = "Series"
    @subtitle = "Series"
  end
end
