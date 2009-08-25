require 'hpricot'

module TaliaCore
  module ActiveSourceParts
    module Xml

      # Helper class to read an attribute hash from a Source XML
      class SourceReader

        class << self

          def sources_from_file(file)
            File.open(file) { |io| sources_from(io) }
          end

          def sources_from(source)
            reader = self.new(source)
            reader.sources
          end

        end

        def initialize(source)
          @doc = Hpricot.XML(source)
        end

        def sources
          return @sources if(@sources)
          
          @sources = []
          (@doc/:source).each do |source|
            @sources << attributes_for_source(source)
          end
          @sources
        end
        
        private
        
        def attributes_for_source(source_xml)
          attributes = {}
          (source_xml/:attribute).each do |attribute|
            add_attribute(attribute, attributes)
          end
          attributes
        end
        
        def add_attribute(attribute_xml, attributes)
          predicate = (attribute_xml/:predicate).inner_html.strip
          if(ActiveSource.db_attr?(predicate))
            attributes[predicate] = (attribute_xml/:value).inner_html.strip
          else
            attributes[predicate] ||= []
            (attribute_xml/:value).each { |val| attributes[predicate] << val.inner_html.strip  }
            (attribute_xml/:object).each { |ob| attributes[predicate] << "<#{ob.inner_html.strip}>"}
          end
          attributes
        end

      end

    end
  end
end