require 'paginator'

# We need the rdf mime type for this: TODO: Find a location to define the mime
# types.
Mime::Type.register "application/rdf+xml", :rdf

class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.xml
  def index
    @sources = TaliaCore::Source.find(:all)
    
    @pager = ::Paginator.new(TaliaCore::SourceRecord.count, 5) do |offset, per_page|
      TaliaCore::Source.find(:all, :limit => per_page, :offset => offset)
    end
    @page = @pager.page(params[:page])

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
    attribute = TaliaCore::Source.find(params[:id])[params[:attribute]]
    status = '404 Not Found' if attribute.nil?
    render :text => attribute.to_s, :status => status
  end

  # GET /sources/1/foaf/friend
  def show_rdf_predicate
    headers['Content-Type'] = Mime::TEXT
    predicates = TaliaCore::Source.find(params[:id]).predicates(params[:namespace], params[:predicate])
    if predicates.nil?
      # This is a workaround: when predicates is nil it tries to render a template with the name of this method.
      predicates = ''
      status = '404 Not Found'
    end
    render :text => predicates, :status => status
  end

  # GET /sources/new
  # GET /sources/new.xml
  def new
    @source = TaliaCore::Source.new(nil)

    respond_to do |format|
      format.html # new.html
      format.xml  { render :xml => @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = TaliaCore::Source.find(params[:id])
  end

  # POST /sources
  # POST /sources.xml
  def create
    @source = TaliaCore::Source.new(params[:source])

    respond_to do |format|
      if @source.save
        flash[:notice] = 'Source was successfully created.'
        format.html { redirect_to(@source) }
        format.xml  { render :xml => @source, :status => :created, :location => @source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = TaliaCore::Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        flash[:notice] = 'Source was successfully updated.'
        format.html { redirect_to(@source) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.xml
  def destroy
    @source = TaliaCore::Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to(sources_url) }
      format.xml  { head :ok }
    end
  end
end
