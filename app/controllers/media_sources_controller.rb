class MediaSourcesController < ApplicationController

  def show
    element_uri = N::LOCAL + request.request_uri[1..-1]
    raise(ArgumentError, "Unknow Media Source #{element_uri}") unless(TaliaCore::Media.exists?(element_uri))
    
    @element = TaliaCore::Media.find(element_uri)
    cat = @element.category
    @path = [ { :text => cat.name, :link => cat.uri }, { :text => @element.title } ]
  end
end
