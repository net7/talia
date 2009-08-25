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
        size, modified, blanks = rdfs_from_owl do |size|
          progress ||= begin
            puts "#{size} OWL classes found, adding rdfs:Class type for each."
            ProgressBar.new("Updating RDF database", size)
          end
          progress.inc
        end
        
        progress.finish if(progress)
        puts "Finished updating. Updated #{modified} of #{size} classes. #{blanks} blank nodes were ignored."
        
      end
      
      # This checks for owl:Classes and adds and rdfs:Class triple to them. This
      # doesn't check if the triple already exists, and thus may cause duplicates.
      # You can pass a block that will be called with the overall size
      # as a parameter.
      #
      # It returns the overall size, the number of modified elements and the
      # number of blank nodes
      def rdfs_from_owl
        # Remove previous auto rdfs triples
        FederationManager.clear(N::TALIA.auto_rdfs.context)
        
        # Get all OWL classes
        qry = Query.new(N::URI).distinct.select(:klass, :type)
        qry.where(:klass, N::RDF::type, N::OWL + 'Class')
        qry.where(:klass, N::RDF::type, :type)
        classes_with_types = qry.execute
        modified = 0
        blanks = 0
        
        class_hash = {}
        
        # We have a list of all combinations of klass elements with their types
        # The next step is to find all things where a RDFS.Class type already
        # exists
        classes_with_types.each do |class_with_type|
          if(class_with_type.first.is_a?(RDFS::BNode))
            blanks = blanks + 1
            next
          end
          
          klass, type = class_with_type
          
          class_hash[klass.to_s] ||= :no_rdfs_class
          class_hash[klass.to_s] = :has_rdfs_class if(type == N::RDFS.Class)
        end
        
        # Now go through all klasses and add the missing triples
        class_hash.each do |klass, status|
          if(status == :has_rdfs_class)
            modified = modified + 1
            FederationManager.add(N::URI.new(klass), N::RDF.type, N::RDFS.Class, N::TALIA.auto_rdfs_context)
          end
          yield(class_hash.size) if(block_given?)
        end
        
        return [class_hash.size, modified, blanks]
      end
      
    end
  end
end
