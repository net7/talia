require 'oai'

module TaliaCore
  module Oai
    
    # This is a wrapper around a ActiveSource that provides the Dublin Core
    # fields to the OAI provider class
    class ActiveSourceAdapterWrapper
      
      dc_field :title, :creator, :subject, :description, :publisher,
        :contributor, :date, :type, :format, :source, :language, :relation,
        :coverage, :rights
      
      private
      
      def initialize(record)
        @record = record
      end
      
      def self.dc_field(*fields)
        fields.each do |field|
          define_method(field.to_sym) do
            @record.predicate(N::DCNS, field.to_s)
          end
        end
      end
      
    end
    
  end
end
