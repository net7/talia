require 'oai'
require File.join(File.dirname(__FILE__), 'active_source_oai_adapter', 'class_methods')

module TaliaCore
  module Oai
    
    # This is a wrapper around a ActiveSource that provides the Dublin Core
    # fields to the OAI provider class
    class ActiveSourceOaiAdapter
      
      extend OaiAdapterClassMethods
      
      namespaced_field :dcns, :title, :creator, :subject, :description, :publisher,
        :contributor, :date, :type, :format, :identifier,
        :source, :language, :relation, :coverage, :rights
      
      namespaced_field :dct, :isPartOf, :abstract
      
      def initialize(record)
        @record = record
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
