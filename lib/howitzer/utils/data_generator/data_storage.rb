module DataGenerator

  module DataStorage
    @data ||= {}

    class << self
      def store(ns, key, value)
        check_ns(ns)
        @data[ns][key] = value
      end

      def extract(ns, key=nil)
        check_ns(ns)
        key ? @data[ns][key] : @data[ns]
      end

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