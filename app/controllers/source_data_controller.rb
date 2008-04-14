class SourceDataController < ApplicationController
  include TaliaCore
  upload_status_for :create
  
  # GET /source_data/1
  def show
    @source_data = DataRecord.find_by_type_and_location!(params[:type], params[:location])
    send_data @source_data.content_string, :type => @source_data.mime_type,
                                    :disposition => 'inline',
                                    :filename => params[:location]
  end
  
  # POST /source_data
  def create
    @data = DataRecord.new(params[:data_record])
    if @data.save
      render :inline => '', :status => 200
    else
      render :inline => '', :status => 500
    end
  end
end
