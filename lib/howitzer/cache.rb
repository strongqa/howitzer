module Howitzer
  ##
  #
  # Data can be stored in memory using this class
  #
  module Cache
    SPECIAL_NS_LIST = [:cloud].freeze #:nodoc:
    @data ||= {}

    class << self
      attr_reader :data

      # Saves data into memory. Marking by a namespace and a key
      #
      # @param namespace [String] a namespace
      # @param key [String] a key that should be uniq within the namespace
      # @param value [Object] everything you want to store in Memory
      # @raise [NoDataError] if the namespace missing

      def store(namespace, key, value)
        check_ns(namespace)
        @data[namespace][key] = value
      end

      # Gets data from memory. Can get all namespace or single data value in namespace using key
      #
      # @param namespace [String] a namespace
      # @param key [String] key that isn't necessary required
      # @return [Object, Hash] all data from the namespace if the key is ommited, otherwise returs
      #   all data for the namespace
      # @raise [NoDataError] if the namespace missing

      def extract(namespace, key = nil)
        check_ns(namespace)
        key ? @data[namespace][key] : @data[namespace]
      end

      # Deletes all data from a namespace
      #
      # @param namespace [String] a namespace

      def clear_ns(namespace)
        init_ns(namespace)
      end

      # Deletes all namespaces with data
      #
      # @param exception_list [Array] a namespace list for excluding

      def clear_all_ns(exception_list = SPECIAL_NS_LIST)
        (@data.keys - exception_list).each { |ns| clear_ns(ns) }
      end

      private

      def check_ns(namespace)
        raise Howitzer::NoDataError, 'Data storage namespace can not be empty' unless namespace

        init_ns(namespace) if ns_absent?(namespace)
      end

      def ns_absent?(namespace)
        !@data.key?(namespace)
      end

      def init_ns(namespace)
        @data[namespace] = {}
      end
    end
  end
end
