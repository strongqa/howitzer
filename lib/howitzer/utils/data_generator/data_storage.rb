module DataGenerator

  ##
  #
  # Data can be stored in memory using this module classes.
  #

  module DataStorage
    @data ||= {}

    class << self

      ##
      #
      # Save data into memory. Marking by namespace and key
      # @param ns [String,Symbol]                       Namespace
      # @param key [String,Symbol]                      Key that should be uniq in namespace
      # @param value [AnyData]                          Data value
      #

      def store(ns, key, value)
        check_ns(ns)
        @data[ns][key] = value
      end

      ##
      #
      # Get data from memory. Can get all namespace or single data value in namespace using key
      # @param ns [String,Symbol] Namespace
      # @param key [String,Symbol] Key that isn't necessary required
      #

      def extract(ns, key=nil)
        check_ns(ns)
        key ? @data[ns][key] : @data[ns]
      end

      ##
      #
      # Delete all records from namespace
      # @param ns [String,Symbol] Namespace
      #

      def clear_ns(ns)
        init_ns(ns)
      end

      private

      def check_ns(ns)
        if ns
          init_ns(ns) if ns_absent?(ns)
        else
          raise 'Data storage namespace can not be empty'
        end
      end

      def ns_absent?(ns)
        !@data.key?(ns)
      end

      def init_ns(ns)
        @data[ns] = {}
      end

    end
  end
end