module DataGenerator

  ##
  #
  # Data can be stored in memory using DataStorage
  #

  module DataStorage
    @data ||= {}

    class << self

      ##
      #
      # Saves data into memory. Marking by namespace and key
      #
      # *Parameters:*
      # * +ns+ - Namespace
      # * +key+ - Key that should be uniq in namespace
      # * +value+ - Data value
      #


      def store(ns, key, value)
        check_ns(ns)
        @data[ns][key] = value
      end

      ##
      #
      # Gets data from memory. Can get all namespace or single data value in namespace using key
      #
      # *Parameters:*
      # * +ns+ - Namespace
      # * +key+ - Key that isn't necessary required (default to: nil)
      #

      def extract(ns, key=nil)
        check_ns(ns)
        key ? @data[ns][key] : @data[ns]
      end

      ##
      #
      # Deletes all records from namespace
      #
      # *Parameters:*
      # * +ns+ - Namespace
      #

      def clear_ns(ns)
        init_ns(ns)
      end

      private

      def check_ns(ns)
        if ns
          init_ns(ns) if ns_absent?(ns)
        else
          log.error 'Data storage namespace can not be empty'
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
