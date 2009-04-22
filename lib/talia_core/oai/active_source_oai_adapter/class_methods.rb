module TaliaCore
  module Oai
    
    module OaiAdapterClassMethods
      
      def namespaced_field(namespace, *fields)
        fields.each do |field|
          define_method(field.to_sym) do
            @record.predicate(namespace, field.to_s).values
          end
        end
      end
      
    end
    
  end
end