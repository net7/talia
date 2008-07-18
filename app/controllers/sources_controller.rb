class SourcesController < ApplicationController
  include TaliaCore
  PER_PAGE = 10
  
  # GET /sources
  # GET /sources.xml
  def index
    # For "normal" operations, we just create a pager
    @source_options = { :page => 1, :per_page => PER_PAGE }
    @sources = TaliaCore::Source.paginate(@source_options)
    
    @types = N::LUCCADOM.elements_with_type(N::RDFS.Class, N::SourceClass)
    @group_increment = 2
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source = TaliaCore::Source.find(params[:id])
    @page_subtitle = @source.uri.to_s
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
      format.rdf { render :xml => @source.to_rdf }
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
end
