require 'talia_util/hyper_xml_import'

class ImportController < ApplicationController
  before_filter :login_required
  
  def create
    respond_to do |format|
      format.xml do
        begin
          # TODO should we move the xml doc creation in #import?
          @document = TaliaUtil::HyperImporter::Importer.import(REXML::Document.new(params[:document]))
          render :inline => 'The source has been created.', :status => :created
        rescue Exception => e
          puts "ERROR: #{e.inspect}"
          render :inline => 'Error', :status => 400
        end
      end
    end
  end
end
