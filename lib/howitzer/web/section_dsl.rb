module Howitzer
  module Web
    # This module combines section dsl methods
    module SectionDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # Returns capybara context. For example, capybara session, parent element, etc.
      # @abstract should be defined in parent context

      def capybara_context
        raise NotImplementedError, "Please define 'capybara_context' method for class holder"
      end

      # This module holds section dsl class methods
      module ClassMethods
        # This class is for private usage only
        class SectionScope
          attr_accessor :section_class

          # Instantiates an anynomous or named section and executes block code in the section scope

          def initialize(name, *args, &block)
            @args = args
            self.section_class =
              if block
                Class.new(Howitzer::Web::BaseSection)
              else
                "#{name}_section".classify.constantize
              end
            instance_eval(&block) if block_given?
          end

          # Defines an element on the section
          # @see Howitzer::PageDsl::ClassMethods#element

          def element(*args)
            section_class.send(:element, *args)
          end

          # Delegates a section describing to the section class

          def section(name, *args, &block)
            section_class.send(:section, name, *args, &block)
          end

          # Returns a selector for the section.
          # @note If anonymous section uses, then inline selector should be specified.
          #   Otherwise arguments should be defined with `.me` dsl method in named section
          # @return [Array]
          # @raise [ArgumentError] when finder arguments were not specified

          def finder_args
            @finder_args ||= begin
              return @args if @args.present?
              section_class.default_finder_args || raise(ArgumentError, 'Missing finder arguments')
            end
          end
        end

        protected

        # DSL method which defines named or anonymous section within a page or a section
        # @note This method generates following dynamic methods:
        #
        #   <b><em>section_name</em>_section</b> - equals capybara #find(...) method
        #
        #   <b><em>section_name</em>_sections</b> - equals capybara #all(...) method
        #
        #   <b><em>section_name</em>_sections.first</b> - equals capybara #first(...) method
        #
        #   <b>has_<em>section_name</em>_section?</b> - equals capybara #has_selector(...) method
        #
        #   <b>has_no_<em>section_name</em>_section?</b> - equals capybara #has_no_selector(...) method
        # @param name [Symbol, String] an unique section name
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Node::Finders#all.
        #  (In most cases should be ommited for named sections because the section selector is specified
        #  with `#me` method. But must be specified for anonymous sections)
        # @param block [Proc] this block can contain nested sections and elements
        # @example Named section
        #   class MenuSection < Howitzer::Web::Section
        #     me :xpath, ".//*[@id='panel']"
        #   end
        #   class HomePage < Howitzer::Web::Page
        #     section :menu
        #   end
        #   HomePage.on { is_expected.to have_menu_section }
        # @example Anonymous section
        #   class HomePage < Howitzer::Web::Page
        #     section :info_panel, '#panel' do
        #       element :edit_button, '.edit'
        #       element :title_field, '.title'
        #
        #       def edit_info(title: nil)
        #         edit_button_element.click
        #         title_field_element.set(title)
        #       end
        #     end
        #   end
        #   HomePage.on { info_panel.edit_info(title: 'Test Title') }
        # @!visibility public

        def section(name, *args, &block)
          scope = SectionScope.new(name, *args, &block)
          define_section_method(scope.section_class, name, scope.finder_args)
          define_sections_method(scope.section_class, name, scope.finder_args)
          define_has_section_method(name, scope.finder_args)
          define_has_no_section_method(name, scope.finder_args)
        end

        private

        def define_section_method(klass, name, args)
          define_method("#{name}_section") do
            klass.new(self, capybara_context.find(*args))
          end
        end

        def define_sections_method(klass, name, args)
          define_method("#{name}_sections") do
            capybara_context.all(*args).map { |el| klass.new(self, el) }
          end
        end

        def define_has_section_method(name, args)
          define_method("has_#{name}_section?") do
            capybara_context.has_selector?(*args)
          end
        end

        def define_has_no_section_method(name, args)
          define_method("has_no_#{name}_section?") do
            capybara_context.has_no_selector?(*args)
          end
        end
      end
    end
  end
end

require 'howitzer/web/base_section'
