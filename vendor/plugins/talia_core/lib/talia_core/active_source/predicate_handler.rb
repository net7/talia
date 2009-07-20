module TaliaCore
  class ActiveSource < ActiveRecord::Base
    # This file contains the handling of the "predicate wrapper" lists
    # that represent the properties/objects a class has for a given predicate

    after_save :save_wrappers

    class << self

      # Attempts to fetch all relations on the given sources at once, so that
      # there is potentially only one.
      #
      # For safety reasons, there is a limit on the number of sources that is
      # accepted. (For a web application, if you go over the default, you're
      # probably doing it wrong).
      def prefetch_relations_for(sources, limit = 1024)
        sources = [ sources ] if(sources.is_a?(ActiveSource))
        raise(RangeError, "Too many sources for prefetching.") if(sources.size > limit)
        src_hash = {}
        sources.each { |src| src_hash[src.id] = src }
        conditions = ['subject_id in (?)', src_hash.keys.join(', ')]
        joins = ActiveSource.sources_join
        joins << ActiveSource.props_join
        relations = SemanticRelation.find(:all, :conditions => conditions,
          :joins => joins,
          :select => SemanticRelation.fat_record_select
        )
        relations.each do |rel|
          src_hash[rel.subject_id].inject_predicate(rel)
        end

        # Set all as loaded
        sources.each do |src|
          src.each_cached_wrapper { |wrap| wrap.instance_variable_set(:'@loaded', true) }
        end
      end

    end # End class methods

    # Gets the types
    def types
      get_objects_on(N::RDF.type.to_s)
    end

    # Returns the objects on the given predicate. This will be cached internally
    # so that the object will always be the same as long as the parent source
    # lives.
    def get_objects_on(predicate)
      @type_cache ||= {}
      active_wrapper = @type_cache[predicate.to_s]
      
      if(active_wrapper.nil?)
        active_wrapper = SemanticCollectionWrapper.new(self, predicate)
        @type_cache[predicate.to_s] = active_wrapper
      end

      active_wrapper
    end

    # Go through the existing relation wrappers and save the (new) items
    def save_wrappers
      each_cached_wrapper do |wrap|
        # Load unloaded if we're not rdf_autosaving. Quick hack since otherwise
        # since the blanking of unloaded properties could cause problems with
        # the rdf writing otherwise
        wrap.send(:load!) unless(wrap.loaded? || autosave_rdf?)
        wrap.save_items!
      end
    end

    # Loops through the cache and passes each existing wrapper to the block
    def each_cached_wrapper
      return unless(@type_cache)
      @type_cache.each_value {  |wrap| yield(wrap) }
    end

    # Clear the source (this will force reloading of elements and discard
    # unsaved changes
    def reset!
      @type_cache = nil
    end

    # Injects a 'fat' predicate relation on a source
    def inject_predicate(fat_relation)
      wrapper = get_objects_on(fat_relation.predicate_uri)
      wrapper.inject_fat_item(fat_relation)
    end

  end
end