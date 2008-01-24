module TaliaUtil
  
  # Some methods to update the RDF store. There is no real inferencing, just
  # some hardcoded rules that help to provide basic functionality with simple
  # RDF stores.
  class RdfUpdate
    
    class << self
      
      # This checks for owl:Classes and adds and rdfs:Class triple to them. This
      # doesn't check if the triple already exists, and thus may cause duplicates.
      def owl_to_rdfs
        puts "Checking for OWL classes."
        # Register the namespaces for ActiveRDF
        Namespace.register(:rdfs, N::RDFS.to_s)
        Namespace.register(:owl, N::OWL.to_s)
        # Get all OWL classes
        qry = Query.new.distinct.select(:s)
        qry.where(:s, make_res(N::RDF::type), make_res(N::OWL + 'Class'))
        klasses = qry.execute
        puts "#{klasses.size} OWL classes found, adding rdfs:Class type for each."
        
        progress = ProgressBar.new("Updating RDF database", klasses.size)
        updated = 0
        
        klasses.each do |klass|
          already_exists = false
          assit_kind_of(RDFS::Resource, klass)
          unless(klass.rdf::type.is_a?(RDFS::Resource) || klass.rdf::type.size < 2)
            klass.rdf::type.each do |type|
              already_exists = true if(type == make_res(N::RDFS + "Class"))
            end
          end
          unless(already_exists)
            klass.rdf::type = make_res(N::RDFS + "Class")
            klass.save
            updated += 1
          end
          
          progress.inc
        end
        
        progress.finish
        puts "Finished updating. Updated #{updated} of #{klasses.size} classes."
      end
      
      # Make a resource
      # Create a resource from the given type
      def make_res(type)
        Module::RDFS::Resource.new(type.to_s)
      end
    end
  end
end
