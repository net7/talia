class OntologiesController < ApplicationController
  
    def index
      onto_qry =  Query.new(N::URI).select(:context).distinct.where(N::TALIA.rdf_context_space, N::TALIA.rdf_file_context, :context)
      @ontologies = onto_qry.execute.collect { |context| context.local_name }
    end
    
    def show
      ontology_url = N::TALIA + URI.encode(params[:id])
      @triples = Query.new(N::URI).select(:s, :p, :o).where(:s, :p, :o, ontology_url).execute
    end
    
end
