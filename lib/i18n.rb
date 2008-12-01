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
      return false unless valid_locale?(code)
      @@locales = locales.merge(name.downcase.to_sym => code)
      reload_locales
      true
    end

    protected
      def sanitize_arguments(name, code)
        [ name.to_s[/^\w+$/], code[/^[a-zA-Z0-9\-]+$/] ]
      end
      
      def valid_locale?(code)
        return false unless RFC_3066.parse(code) rescue nil
        code = code.split(/(\-|\_)/)
        language, country = code.first, code.last
        Language.find_by_iso_639_1(language) && Country.find_by_code(country)
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