module TaliaUtil
  
  # Some methods to update the RDF store. There is no real inferencing, just
  # some hardcoded rules that help to provide basic functionality with simple
  # RDF stores.
  class RdfUpdate
    
    class << self
      
      # This is the wrapper for rdfs_from_owl for the rake task
      def owl_to_rdfs
        puts "Checking for OWL classes."
        # Register the namespaces for ActiveRDF
        Namespace.register(:rdfs, N::RDFS.to_s)
        Namespace.register(:owl, N::OWL.to_s)
        progress = nil
        size, modified = rdfs_from_owl do |size, inc|
          progress ||= begin
            puts "#{size} OWL classes found, adding rdfs:Class type for each."
            ProgressBar.new("Updating RDF database", size)
          end
          progress.inc
        end
        
        progress.finish if(progress)
        puts "Finished updating. Updated #{modified} of #{size} classes."
        
      end
      
      # This checks for owl:Classes and adds and rdfs:Class triple to them. This
      # doesn't check if the triple already exists, and thus may cause duplicates.
      # You can pass a block that will be called with the overall size
      # and the current increment (0 or 1, depending on if a class was added or
      # not) as parameters.
      def rdfs_from_owl
        # Get all OWL classes
        qry = Query.new.distinct.select(:s)
        qry.where(:s, make_res(N::RDF::type), make_res(N::OWL + 'Class'))
        klasses = qry.execute
        modified = 0
        
        klasses.each do |klass|
          already_exists = false
          assit_kind_of(RDFS::Resource, klass)
          unless(klass.rdf::type.is_a?(RDFS::Resource) || klass.rdf::type.size < 2)
            klass.rdf::type.each do |type|
              already_exists = true if(type == make_res(N::RDFS + "Class"))
            end
          end
          updated = 0
          unless(already_exists)
            klass.rdf::type = make_res(N::RDFS + "Class")
            klass.save
            updated = 1
          end
          
          modified += updated
          yield(klasses.size, updated) if(block_given?)
        end
        
        return [klasses.size, modified]
      end
      
      # Make a resource
      # Create a resource from the given type
      def make_res(type)
        ::RDFS::Resource.new(type.to_s)
      end
    end
  end
end
