module ActionController #:nodoc:
  module Caching #:nodoc:
    module Actions #:nodoc:
      class ActionCachePath #:nodoc:
        def initialize(controller, options = {})
          @extension = extract_extension(controller.request.path)
          @locale = controller.send(:current_locale) rescue nil
          path = controller.url_for(options).split('://').last
          normalize!(path)
          add_extension!(path, @extension)
          add_locale!(path, @locale)
          @path = URI.unescape(path)
        end
        
        private
          def add_locale!(path, locale)
            path << "?locale=#{locale}" if locale
          end
      end
    end
  end
end
