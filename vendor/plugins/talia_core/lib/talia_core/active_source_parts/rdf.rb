module TaliaCore
  module ActiveSourceParts

    module Rdf
      # This file contains the RDF handling elements of the ActiveSource class

      # This can be used to turn of automatic rdf creation. *Attention:* Improperly
      # used this may compromise the integrity of the RDF data. However, it may
      # be used in order to speed up "create" operations that save a record
      # several times and don't need the RDF data in the meantime.
      def autosave_rdf?
        @autosave_rdf = true unless(defined?(@autosave_rdf))
        @autosave_rdf
      end

      # Set the autosave property. See autosave_rdf?
      def autosave_rdf=(value)
        @autosave_rdf = value
      end

      # Returns the RDF object to use for this ActiveSource
      def my_rdf
        @rdf_resource ||= begin
          src = RdfResource.new(uri)
          src.object_class = TaliaCore::ActiveSource
          src
        end
      end

      # This creates the RDF subgraph for this Source and saves it to disk. This
      # may be an expensive operation since it removes the existing elements.
      # (Could be optimised ;-)
      #
      # Unless the force option is specified, this will ignore predicates that
      # remain unchanged. This means that writing will be faster if a predicate
      # will not changed, but if database objects were not added through the
      # standard API they'll be missed
      def create_rdf(force = false)
        self.class.benchmark("\033[32m\033[4m\033[1mActiveSource::RD\033[0m Creating RDF for source", Logger::DEBUG, false) do
          assit(!new_record?, "Record must exist here: #{self.uri}")
          # Get the stuff to write. This will also erase the old data
          s_rels = force ? prepare_all_predicates_to_write : prepare_predicates_to_write
          s_rels.each do |sem_ref|
            # We pass the object on. If it's a SemanticProperty, we need to add
            # the value. If not the RDF handler will detect the #uri method and
            # will add it as Resource.
            obj = sem_ref.object
            value = obj.is_a?(SemanticProperty) ? obj.value : obj
            my_rdf.direct_write_predicate(N::URI.new(sem_ref.predicate_uri), value)
          end
          my_rdf.direct_write_predicate(N::RDF.type, (N::TALIA + self.class.name.demodulize))
          my_rdf.save
        end
      end
      
      # Creates an RDF/XML resprentation of the source
      def to_rdf
        rdf = String.new

        ActiveSourceParts::Xml::RdfBuilder.open(:target => rdf, :indent => 2) do |builder|
          builder.write_source(self)
        end

        rdf
      end

      private

      # Get the "standard" predicates to write (which is just the ones changed
      # through the standard API. This will erase the
      def prepare_predicates_to_write
        preds_to_write = []
        each_cached_wrapper do |wrap|
          # If it wasn't loaded, it hasn't been written to
          next if(wrap.clean?)
          # Remove the existing data. TODO: Not using contexts
          my_rdf.remove(N::URI.new(wrap.instance_variable_get(:@assoc_predicate)))
          items = wrap.send(:items) # Get the items
          items.each { |it| preds_to_write << it.relation }
        end
        preds_to_write
      end

      # This will get all existing predicates from the database. This will also
      # erase the rdf for this source completely
      # TODO: Could load with a single sql
      def prepare_all_predicates_to_write
        my_rdf.clear_rdf # TODO: Not using contexts here
        SemanticRelation.find(:all, :conditions => { :subject_id => self.id })
      end

      def auto_create_rdf
        if(autosave_rdf?)
          create_rdf
        end
      end

    end
  end
end
