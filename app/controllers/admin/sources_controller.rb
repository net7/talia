require 'paginator'

class Admin::SourcesController < ApplicationController
  before_filter :login_required
  include TaliaCore
  layout 'sources'
  
  # GET /sources
  # GET /sources.xml
  def index
    @sources = Source.paginate :page => params[:page], :per_page => 10
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sources }
      format.js do
        render :update do |page|
          page.replace_html 'sources', :partial => 'sources'
        end
      end
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        flash[:notice] = 'Source was successfully updated.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end
end