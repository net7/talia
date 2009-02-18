require 'paginator'

class Admin::SourcesController < ApplicationController
  include TaliaCore
  require_role 'admin'
  layout 'admin'
  cache_sweeper :av_media_sweeper, :only => :update
  
  # GET /admin/sources
  # GET /admin/sources.xml
  def index
    @sources = TaliaCore::Source.paginate :page => params[:page], :per_page => 10
    
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

  # GET /admin/sources/1/edit
  def edit
    @source = TaliaCore::Source.find_by_partial_uri(params[:id])
  end

  # PUT /admin/sources/1
  # PUT /admin/sources/1.xml
  def update
    @source = TaliaCore::Source.find_by_id(params[:id])

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
    # We need to specify the clause, because of Source#find overwrite the
    # default behavior.
    @source = TaliaCore::Source.find_by_id(params[:id])
    
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
  
  # GET /admin/sources/auto_complete_for_source/aaa
  def auto_complete_for_source
    @items = TaliaCore::Source.find_by_uri_token(params[:source][:predicates_attributes].first[:titleized])
    render :inline => "<%= auto_complete_result @items, 'titleized' %>"
  end
end
