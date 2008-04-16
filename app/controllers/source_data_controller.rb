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
    status = DataRecord.find_or_create_and_assign_file(params[:data_record]) ? 200 : 500
    render :inline => '', :status => status
  end

  # DELETE /source_data/1
  def destroy
    @source_data = DataRecord.find(params[:id])
    @source = @source_data.source_record
    @source_data.destroy
    render :update do |page|
      page.replace_html 'list', :partial => "admin/sources/data", :collection => @source.data
      page.insert_html :top, 'data', :partial => 'admin/sources/notice', :locals => { :text => 'Your file has been destroyed.'}
      page[:data_notice].visual_effect :highlight
      page[:data_notice].visual_effect :fade, :duration => 3
      page.delay(3.1) { page.remove :data_notice }
    end
  end
end
