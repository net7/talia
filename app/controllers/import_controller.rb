require 'talia_util/hyper_xml_import'

class ImportController < ApplicationController
  before_filter :login_required
  
  def create
    respond_to do |format|
      format.xml do
        begin
          xml = REXML::Document.new(params[:document])
          # TODO: This is currently more than stupid, since it will write
          # a single source. However, this controller may be deprecated anyway

          uri = TaliaUtil::HyperImporter::Importer.import(xml)
          TaliaUtil::HyperImporter::Importer.write_imported!
          render :inline => 'The source has been created.', :status => :created, :location => uri.to_s
        rescue Exception => e
          render :xml => e.message, :status => :unprocessable_entity
        end
      end
    end
  end
end
