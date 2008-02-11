require 'rexml/document'
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaUtil
  class UtilHelper
    class << self
      
      # Loads a test document
      def load_doc(name)
        demo_docs ||= {}
        demo_docs[name] ||= begin
          current_dir = File.expand_path(File.dirname(__FILE__))
          REXML::Document.new(File.open(File.join(current_dir, 'import_samples', "#{name}.xml")))
        end
        demo_docs[name]
      end
      
    end
  end
end
