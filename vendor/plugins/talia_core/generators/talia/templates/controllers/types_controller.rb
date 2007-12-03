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
    parts = params[:id].split("#")
    @type = N::SourceClass.new(N::Namespace[parts[0]] + parts[1])
    @page_title = "Talia | #{@type.to_name_s}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end
   
end
