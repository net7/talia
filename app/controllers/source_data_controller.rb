class SourceDataController < ApplicationController
  # GET /source_data/1
  def show
    @source_data = TaliaCore::DataRecord.find_by_type_and_location!(params[:type], params[:location])
    send_data @source_data.content_string, :type => @source_data.mime_type,
                                    :disposition => 'inline',
                                    :filename => params[:location]
  end
end
