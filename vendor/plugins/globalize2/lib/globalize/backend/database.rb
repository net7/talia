require 'activerecord'
require 'globalize/backend/static'

module Globalize
  module Backend
    class Database < Static
      def store_translations(locale, data)
        data.each { |key, data| Translation.create_or_update(locale, key, data) }
      end

      def pluralize(locale, entry, count)
        count ||= default_count
        super
      end

      protected
        def lookup(locale, key, scope = [])
          # TODO find in the cache
          # TODO if missing find into database
          # TODO store in the cache and return an hash based translation, grouped by pluralization index
          Translation.fetch(locale, key)
        end

        # TODO choose a default pluralization_index value
        def default_count
          1
        end

      class Translation < ::ActiveRecord::Base
        set_table_name 'globalize_translations'
        
        class << self
          def create_or_update(locale, key, data)
            # TODO choose a default pluralization_index value
            data = { 'one' => data } if data.is_a? String
            locale, key = locale.to_s, key.to_s

            data.each do |pluralization_index, text|
              if record = find_by_locale_and_key_and_pluralization_index(locale, key, pluralization_index)
                record.update_attribute(:text, text)
              else
                create :locale => locale, :key => key, :pluralization_index => pluralization_index.to_s, :text => text
              end
            end
          end

          def fetch(locale, key)
            result = find_all_by_locale_and_key(locale.to_s, key.to_s, :select => ['pluralization_index, text'])
            return if result.empty?

            result.inject({}) do |result, record|
              record = record.attributes
              result[record.delete('pluralization_index').to_sym] = record['text']
              result
            end
          end
        end
      end
    end
  end
end
