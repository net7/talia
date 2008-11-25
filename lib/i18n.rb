# TODO delete me when upgrade to Rails 2.2.2
require 'yaml'

module I18n
  @@configuration = File.join(RAILS_ROOT, 'config', 'locales.yml').freeze
  mattr_reader :configuration

  class << self
    def locales
      @@locales ||= YAML.load_file(configuration).to_hash.symbolize_keys!
    end

    # Add a locale
    #
    # Example:
    #   I18n.add_locale(:italian, "it-IT")
    def add_locale(name, code)
      name, code = sanitize_arguments(name, code)
      @@locales = locales.merge(name.downcase.to_sym => code)
      reload_locales
      true
    end

    protected
      def sanitize_arguments(name, code)
        [ name.to_s[/^\w+$/], code[/^[a-zA-Z0-9\-]+$/] ]
      end

    private
      def reload_locales
        File.atomic_write(configuration, "./") do |file|
          file.write(@@locales.to_yaml)
        end
        @@locales = nil
        locales
      end
  end
end