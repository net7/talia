require 'oai'
require_or_load File.join(File.dirname(__FILE__), 'active_source_oai_adapter', 'class_methods')

module TaliaCore
  module Oai
    
    # This is a wrapper around a ActiveSource that provides the Dublin Core
    # fields to the OAI provider class
    class ActiveSourceOaiAdapter
      
      extend OaiAdapterClassMethods
      
      namespaced_field :dcns, :title, :subject, :description, :publisher,
        :contributor, :date, :format,
        :source, :language, :relation, :coverage, :rights
      
      namespaced_field :dct, :isPartOf, :abstract

      # namespaced field for Europeana
      namespaced_field :userTag, :unstored, :object, :provider,
                       :uri, :year, :hasObject, :country
      
      # Type information. Base class is not terribly useful, but needed to
      # overwrite default #type method
      def type
        ''
      end
      
      def initialize(record)
        @record = record
      end
      
      # Get the author/creator
      def creator
        @record.dcns::creator.collect do |creator|
          if(creator.is_a?(TaliaCore::ActiveSource))
            author = ''
            author_name = creator.hyper::author_name.first
            author << author_name << ' ' if(author_name)
            author_surname = creator.hyper::author_surname.first || ''
            author << author_surname if(author_surname)
            author = "No lookup. Author should be at #{creator.uri}" if(author == '')
            author
          else
            creator
          end
        end
      end
      
      # Identifier for the resource
      def identifier
        @record.uri.to_s
      end
      
      # Timestamp for the record
      def timestamp
        @record.created_at
      end
      
      # Id for the record
      def id
        @record.id
      end
      
      # Tries to instanciate a wrapper object for the record, using the 
      # wrapper class that corresponds to the given record's class
      def self.get_wrapper_for(record)
        cand_class = "TaliaCore::Oai::#{record.class.name.demodulize}Adapter"
        wrapper = nil
        begin
          klass = cand_class.constantize
          wrapper = klass.new(record)
        rescue NameError
          # Falling back to standard class if specific class didn't autoload
        end
        wrapper ||= ActiveSourceOaiAdapter.new(record)
      end      

      
    end
    
  end
end
