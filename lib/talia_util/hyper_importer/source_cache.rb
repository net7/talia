module TaliaUtil
  module HyperImporter

    # Class to cache source objects for reuse. This uses a simple generational
    # approach: If the "current" cache is full, it will be re-assigned as the
    # 2nd generation and a new, empty 1st generation created. The old
    # 2nd generation will be discarded
    #
    # If a hit is found in the 2nd generation, it will be re-added to the first
    # generation cache.
    class SourceCache

      # Size of the first generation cache. Cumulative size may be up two
      # two times this size.
      GENERATION_SIZE = 2000

      # Get the single cache object, creating it if necessary.
      def self.cache
        @source_cache ||= SourceCache.new(GENERATION_SIZE)
      end

      # Initialize a cache with the given generation size
      def initialize(gen_size)
        @generation_size = gen_size
        @first_generation = {}
        @second_generation = {}
      end

      # Clear the whole cache
      def clear
        @first_generation = {}
        @second_generation = {}
      end

      # Getter method for the source with the given uri.
      # This will automatically retrieve the source if it's not
      # found in the cache. This will simply return nil if the source is not
      # found at all (so that it also implicitly checks for the existence of
      # the source).
      def [](source_uri)
        source_uri = source_uri.uri if(source_uri.respond_to?(:uri))
        if(cached = @first_generation[source_uri])
          logger.debug("\033[1m\033[4m\033[35mSource Cache\033[0m Cache hit")
          cached # return the cache value
        elsif(cached = @second_generation[source_uri])
          logger.debug("\033[1m\033[4m\033[35mSource Cache\033[0m Cache hit 2nd gen")
          # try the second generation. If found, add back to the first
          add_value(source_uri, cached)
          cached
        else
          logger.debug("\033[1m\033[4m\033[35mSource Cache\033[0m Cache miss")
          # Cache miss: Do the database lookup
          src = TaliaCore::ActiveSource.find(:first, :conditions => {:uri => source_uri })
          add_value(source_uri, src)
          src
        end
      end
      alias :get_value :[]

      # Manually add to the cache. This can be used to update an existing entry.
      def []=(source_uri, value)
        source_uri = source_uri.uri if(source_uri.respond_to?(:uri))
        add_value(source_uri, value)
      end

      private

      # Gain access to the logger
      def logger
        TaliaCore.logger
      end
      

      # Add a value to the cache. Note that uri must be a string!
      def add_value(uri, value)
        # Check if we need to clean the cache
        if(@first_generation.size > @generation_size)
          @second_generation = @first_generation
          @first_generation = {}
        end
        @first_generation[uri] = value
      end

    end
  end
end
