require 'oai'
require_or_load File.join(File.dirname(__FILE__), 'active_source_oai_adapter', 'class_methods')

module TaliaCore
  module Oai
    
    # This is a wrapper around a ActiveSource that provides the Dublin Core
    # fields to the OAI provider class
    class ActiveSourceOaiAdapter
      
      extend OaiAdapterClassMethods
      
      namespaced_field :dcns, :title, :description, 
        :contributor, :date, :format,
        :source, :language, :relation, :coverage, :rights
      
      namespaced_field :dct, :isPartOf, :abstract

      namespaced_field :dcns, :alternative, :conforms_to

      namespaced_field :dct, :created, :extent, :hasFormat, :hasPart,
        :hasVersion, :isFormatOf, :isPartOf, :isReferencesBy,
        :isReplacedBy, :isRequiredBy, :isVersionOf,
        :medium, :provenance, :references, :replaces, :requires, :spatial,
        :tableOfContents, :temporal

      #      namespaced_field :hyper, :is_shown_by, :is_shown_at, :user_tag, :unstored,
      #        :object, :provider, :uri, :year, :has_object, :country


      def type(namespace = nil)
        if namespace.nil?
          ''
        else
          case namespace.to_sym
          when :dc
            @record.predicate('dcns', 'type').values
          when :ese
            @record.predicate('hyper', 'type').values.to_s.upcase
          end
        end
      end

      def language(namespace = nil)
        case namespace
        when :dc
          @record.predicate('dcns', 'language').values
        when :ese
          @record.predicate('hyper', 'language').values
        end
      end

      def issued(namespace = nil)
        result = []
        result << @record.predicate('dct', 'issued').values
        result << @record.predicate('hyper', 'digital_date').values
        result.join(', ')
      end

      def publisher(namespace = nil)
        result = []
        result << @record.predicate('dcns', 'publisher').values
        result << @record.predicate('hyper', 'digital_publisher').values
        result.join(', ')
      end

      def subject(namespace = nil)
        result = []
        result << @record.predicate('dcns', 'subject').values
        result.join(', ')
      end


      def isShownBy(namespace = nil)
        @record.predicate('hyper', 'isShownBy').values
      end

      def isShownAt(namespace = nil)
        @record.predicate('hyper', 'isShownAt').values
      end

      def userTag(namespace = nil)
        @record.predicate('hyper', 'userTag').values
      end
      
      def unstored(namespace = nil)
        @record.predicate('hyper', 'unstored').values
      end

      def object(namespace = nil)
        @record.predicate('hyper', 'object').values
      end

      def provider(namespace = nil)
        result = @record.predicate('hyper', 'provider').values
      end

      def uri(namespace = nil)
        @record.predicate('hyper', 'uri').values
      end

      def year(namespace = nil)
        @record.predicate('hyper', 'year').values
      end

      def hasObject(namespace = nil)
        @record.predicate('hyper', 'hasObject').values
      end

      def country(namespace = nil)
        @record.predicate('hyper', 'country').values
      end
      
      def initialize(record)
        @record = record
      end
      
      # Get the author/creator
      def creator(namespace = nil)
#                @record.dcns::creator.collect do |creator|
#                  if(creator.is_a?(TaliaCore::ActiveSource))
#                    author = ''
#                    author_name = creator.hyper::author_name.first
#                    author << author_name << ' ' if(author_name)
#                    author_surname = creator.hyper::author_surname.first || ''
#                    author << author_surname if(author_surname)
#                    author = "No lookup. Author should be at #{creator.uri}" if(author == '')
#                    author
#                  else
#                    creator
#                  end

        result = []
        result << @record.predicate('dcns', 'creator').values
        result << @record.predicate('hyper', 'editor').values
        result.join(', ')

      end
      
      # Identifier for the resource
      def identifier(namespace = nil)
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
