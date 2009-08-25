class SourcesController < ApplicationController
  include TaliaCore
  
  before_filter :setup_format
  
  PER_PAGE = 10
  
  # GET /sources
  # GET /sources.xml
  def index

  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    raise(ActiveRecord::RecordNotFound) unless(ActiveSource.exists?(params[:id]))
    @source = ActiveSource.find(params[:id])
    respond_to do |format|
      format.xml { render :text => @source.to_xml }
      format.rdf { render :text => @source.to_rdf }
      format.html { render }
    end
  end

  # GET /sources/1/name
  def show_attribute
    headers['Content-Type'] = Mime::TEXT
    attribute = TaliaCore::Source.find(params[:source_id])[params[:attribute]]
    status = '404 Not Found' if attribute.nil?
    render :text => attribute.to_s, :status => status
  end

  # GET /sources/1/foaf/friend
  def show_rdf_predicate
    headers['Content-Type'] = Mime::TEXT
    predicates = TaliaCore::Source.find(params[:id]).predicate(params[:namespace], params[:predicate])
    if predicates.nil?
      # This is a workaround: when predicates is nil it tries to render a template with the name of this method.
      predicates = ''
      status = '404 Not Found'
    end
    render :text => predicates, :status => status
  end
  
  private 
  
  
  # Hack around routing limitation: We use the @ instead of the dot as a delimiter
  def setup_format
    split_id = params[:id].split('@')
    assit(split_id.size <= 2)
    params[:id] = split_id.first
    params[:format] = (split_id.size > 1) ? split_id.last : 'html'
  end
  
  
  def get_uri
    
  end
  
end
