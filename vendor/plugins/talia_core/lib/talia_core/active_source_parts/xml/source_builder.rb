module TaliaCore
  module ActiveSourceParts
    module Xml
      
      # Class to build source representations of ActiveSource objects. Talia 
      # uses a simple XML format to encode the Source Object. The format
      # maps easily to a Hash as it is used for the new or write_attributes 
      # methods:
      #
      #   <sources>
      #     <source>
      #       <attribute>
      #         <predicate>http://foobar/</predicate>
      #         <object>http://barbar/</object>
      #       </attribute>
      #       ...
      #     </source>
      #     <source>
      #       <attribute>
      #         <predicate>http://foobar/bar/</pedicate>
      #         <value>val</value>
      #         <object>http://some_url</object>
      #         <value>another</value>
      #         ...
      #       </attribute>
      #       ...
      #     </source>
      #     ...
      #   </sources>
      class SourceBuilder < BaseBuilder
        
        # Builds the RDF for a single source
        def write_source(source)
          @builder.source do 
            source.attributes.each { |attrib, value| write_attribute(attrib, value) }
            source.direct_predicates.each { |pred| write_attribute(pred, source[pred]) } 
          end
        end
        
        private
        
        # build an attribute entry in a source
        def write_attribute(predicate, values)
          predicate = predicate.respond_to?(:uri) ? predicate.uri.to_s : predicate.to_s
          values = [ values ] unless(values.respond_to?(:each))
          @builder.attribute do 
            @builder.predicate { @builder.text!(predicate) }
            values.each { |val| write_target(val) }
          end
        end
        
        # Writes a value or object tag, depeding on the target
        def write_target(target)
          if(target.respond_to?(:uri))
            @builder.object { @builder.text!(target.uri.to_s) }
          else
            @builder.value { @builder.text!(target.to_s) }
          end
        end
        
        # Build the structure for the XML file and pass on to
        # the given block
        def build_structure
          @builder.sources do 
            yield
          end
        end
        
      end
    
    end
  end
end