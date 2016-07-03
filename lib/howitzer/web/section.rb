require_relative 'base_section'

module Howitzer
  module Web
    # describe me later!
    class Section < BaseSection
      def self.me(*args)
        raise ArgumentError, 'Finder arguments are missing' if args.blank?
        @default_finder_args = args
      end
      private_class_method :me
    end

    # class MenuSection < Section
    #   me :xpath, '//div'
    #
    #   element :foo, '#id'
    #
    #   def bar
    #     1
    #   end
    # end
    #
    # class SomePage
    #   section :menu #from class
    #
    #   section :sidebar, :id, 'side_bar' do
    #     element :link, :href, 'https://google.com'
    #
    #     def foo
    #       2
    #     end
    #   end
    #
    #   def click_foo
    #     menu_section.foo_element.click
    #     sidebar_section.link_element.click
    #   end
    # end
  end
end
