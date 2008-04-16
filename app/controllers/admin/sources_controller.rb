require 'paginator'

class Admin::SourcesController < ApplicationController
  require_role 'admin'
  layout 'sources'
  include TaliaCore
  
  # GET /admin/sources
  # GET /admin/sources.xml
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

  # GET /admin/sources/1
  # GET /admin/sources/1.xml
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end

  # GET /admin/sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  # PUT /admin/sources/1
  # PUT /admin/sources/1.xml
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
  
  # GET /admin/sources/data/1
  def data
    @source = SourceRecord.find(params[:id])
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'list', :partial => 'list'
          page.insert_html :top, 'data', :partial => 'notice', :locals => { :text => 'Your file has been saved.'}
          page[:data_notice].visual_effect :highlight
          page[:data_notice].visual_effect :fade, :duration => 3
          page.delay(3.1) { page.remove :data_notice }
        end
      end
    end
  end
end
