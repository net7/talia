class SourceDataController < ApplicationController

  # GET /sources
  # GET /sources.xml
  def index
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source_data = TaliaCore::DataRecord.find(:first, :conditions => ["type = ? AND location = ?", params[:type].camelize, params[:location]] )
    raise ActiveRecord::RecordNotFound if @source_data.nil?
    send_data @source_data.content_string, :type => @source_data.mime_type,
                                    :disposition => 'inline',
                                    :filename => params[:location]
  end

  # GET /sources/new
  # GET /sources/new.xml
  def new
  end

  # GET /sources/1/edit
  def edit
  end

  # POST /sources
  # POST /sources.xml
  def create
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
  end

  # DELETE /sources/1
  # DELETE /sources/1.xml
  def destroy
  end
end
