require 'talia_util/hyper_xml_import'

class ImportController < ApplicationController
  before_filter :login_required
  
  def create
    respond_to do |format|
      format.xml do
        begin
          # TODO should we move the xml doc creation in #import?
          @document = TaliaUtil::HyperImporter::Importer.import(REXML::Document.new(params[:document]))
          render :inline => 'The source has been created.', :status => :created, :location => @document.uri.to_s
        rescue Exception => e
          render :xml => e.message, :status => :unprocessable_entity
        end
      end
    end
  end
end
