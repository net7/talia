class TypesController < ApplicationController

  # GET /sources
  # GET /sources.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @type = N::SourceClass.make_uri(params[:id], "_")
    @page_title = "Talia | #{@type.to_name_s}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end
   
end
