module TaliaUtil
  
  module HyperImporter
    
    # Should not be called directly, this is a superclass with common 
    # functionality for all contributions
    class ContributionImporter < Importer
      
      def import!
        assit_fail("Abstract importer, should not be called directly")
      end
      
      # This contains all the "default" import functionality for contributions
      def contribution_import!
        add_rel_from(@element_xml, 'author')
        add_property_from(@element_xml, 'publishing_date')
        add_property_from(@element_xml, 'publisher')
        add_property_from(@element_xml, 'language')
        add_property_from(@element_xml, 'alreadyPublished')
        add_property_from(@element_xml, 'curator_notes')
        import_file!
        import_authors!
        add_manifestation_of_clones
      end
      
      # If the source of which this is a manifestation has some previously created
      # clones, add this as a manifestation of them too.
      def add_manifestation_of_clones
        related_sources = TaliaCore::Source.find(@source::hyper.manifestation_of)
        related_sources.each do |related_source|
          qry = Query.new(TaliaCore::Source).select(:clone).distinct
          qry.where(:concordance, N::HYPER.concordant_to, related_source)
          qry.where(:concordance, N::HYPER.concordant_to, :clone)
          # now it finds *every* concordant source, even the related_source one
          # TODO: filter it out, it already has the manifestation_of relation
          #         qry.filter("(?clone != '<#{related_source}>')")
          clones = qry.execute
          clones.each do |clone|
            @source::hyper.manifestation_of << clone
          end unless clones.empty?
        end unless related_sources.empty?
      end
      
      # Import a list of curators and the curator's note for the contribution
      def import_authors!
        @element_xml.root.elements.each('authors/author') do |author|
          if(author_sig = author.text)
            author_sig = author_sig.strip
            add_source_rel(N::DCNS.creator, author_sig)
          else
            assit_fail("Empty author found for #{src.uri.local_name}")
          end
        end
      end
      
    end
  end
end
