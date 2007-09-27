module ActionController  
  module RecordIdentifier
    def singular_class_name(record_or_class)
      class_from_record_or_class(record_or_class).underscore.tr('/', '_')
    end
    
    private
    def class_from_record_or_class(record_or_class)
      klass = record_or_class.is_a?(Class) ? record_or_class : record_or_class.class
      klass.to_s.demodulize
    end
  end
end