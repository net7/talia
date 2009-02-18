module ActionController #:nodoc:
  module Caching #:nodoc:
    module Actions #:nodoc:
      class ActionCacheFilter #:nodoc:
        private
          def path_options_for(controller, options) #:nodoc:
            options[:cache_path].respond_to?(:call) ? options[:cache_path].call(controller) : options
          end
      end
      
      class ActionCachePath #:nodoc:
        def initialize(controller, options = {})
          path_options = options.dup
          @extension = extract_extension(controller.request.path)
          locale = path_options.delete(:locale)
          path = controller.url_for(path_options).split('://').last
          normalize!(path)
          add_extension!(path, @extension)
          add_locale!(path, controller, locale)
          @path = URI.unescape(path)
        end
        
        private
          def add_locale!(path, controller, locale) #:nodoc:
            return unless locale
            
            locale = case locale
              when Symbol
                controller.send(locale)
              when Proc
                locale.call(controller)
              when String
                locale
              else
                raise ArgumentError.new("Locale must be a Symbol, a Proc or a String.")
            end

            path << "?locale=#{locale}"
          end
      end
    end
  end
end
