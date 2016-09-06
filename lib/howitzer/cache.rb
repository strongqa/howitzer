module Howitzer
  ##
  #
  # Data can be stored in memory using this class
  #
  module Cache
    SPECIAL_NS_LIST = [:cloud].freeze
    @data ||= {}

    class << self
      attr_reader :data

      # Saves data into memory. Marking by namespace and key
      #
      # @param ns [String] Namespace
      # @param key [String] Key that should be uniq within namespace
      # @param value [Object] Everything you want to store in Memory
      # @raise error if namespace missing

      def store(ns, key, value)
        check_ns(ns)
        @data[ns][key] = value
      end

      # Gets data from memory. Can get all namespace or single data value in namespace using key
      #
      # @param ns [String] Namespace
      # @param key [String] Key that isn't necessary required
      # @return [Object, Hash] if the key is ommited then returns all data from the namespace
      # @raise error if namespace missing

      def extract(ns, key = nil)
        check_ns(ns)
        key ? @data[ns][key] : @data[ns]
      end

      # Deletes all data from namespace
      #
      # @param ns [String] Namespace

      def clear_ns(ns)
        init_ns(ns)
      end

      # Deletes all namespaces with data
      #
      # @param exception_list [Array] namespace list for excluding

      def clear_all_ns(exception_list = SPECIAL_NS_LIST)
        (@data.keys - exception_list).each { |ns| clear_ns(ns) }
      end

      private

      def check_ns(ns)
        if ns
          init_ns(ns) if ns_absent?(ns)
        else
          Howitzer::Log.error 'Data storage namespace can not be empty'
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
