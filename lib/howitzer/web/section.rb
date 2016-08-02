require 'howitzer/web/base_section'
require 'howitzer/web/section_dsl'

module Howitzer
  module Web
    # describe me later!
    class Section < BaseSection
      class << self
        protected

        def me(*args)
          raise ArgumentError, 'Finder arguments are missing' if args.blank?
          @default_finder_args = args
        end
      end
    end
  end
end
