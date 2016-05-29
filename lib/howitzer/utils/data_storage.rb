module Howitzer
  module Utils
    ##
    #
    # Data can be stored in memory using DataStorage
    #
    module DataStorage
      SPECIAL_NS_LIST = ['sauce'].freeze
      @data ||= {}

      class << self
        attr_reader :data
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

        def extract(ns, key = nil)
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

        ##
        #
        # Deletes all namespaces with data
        #
        # *Parameters:*
        # * +exception_list+ - Array of special namespaces for excluding
        #

        def clear_all_ns(exception_list = SPECIAL_NS_LIST)
          (@data.keys - exception_list).each { |ns| clear_ns(ns) }
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
end
