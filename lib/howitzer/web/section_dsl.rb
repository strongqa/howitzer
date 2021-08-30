require 'howitzer/web/capybara_context_holder'
module Howitzer
  module Web
    # This module combines section dsl methods
    module SectionDsl
      include CapybaraContextHolder

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      # This module holds section dsl class methods
      module ClassMethods
        # This class is for private usage only
        class SectionScope
          attr_accessor :section_class

          # Instantiates an anynomous or named section and executes block code in the section scope

          def initialize(name, *args, **options, &block)
            @args = args
            @options = options
            self.section_class =
              if block
                Class.new(Howitzer::Web::BaseSection)
              else
                "#{name}_section".classify.constantize
              end
            instance_eval(&block) if block_given?
          end

          # # Defines an element on the section
          # # @see Howitzer::Web::ElementDsl::ClassMethods#element

          def element(*args, **options)
            section_class.send(:element, *args, **options)
          end

          # Delegates a section describing to the section class

          def section(name, *args, **options, &block)
            section_class.send(:section, name, *args, **options, &block)
          end

          # Returns selector arguments for the section.
          # @note If anonymous section uses, then inline selector should be specified.
          #   Otherwise arguments should be defined with `.me` dsl method in named section
          # @return [Array]
          # @raise [ArgumentError] when finder arguments were not specified

          def finder_args
            return @args if @args.present?

            @finder_args ||= (section_class.default_finder_args || raise(ArgumentError, 'Missing finder arguments'))
          end

          # Returns selector options for the section.
          # @note If anonymous section uses, then inline selector should be specified.
          #   Otherwise arguments should be defined with `.me` dsl method in named section
          # @return [Array]
          # @raise [ArgumentError] when finder arguments were not specified

          def finder_options
            @options if @args.present? # it is ok to have blank options, so we rely here on the argments

            @finder_options ||= (section_class.default_finder_options || {})
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
        # @note It is possible to use nested anonymous sections
        # @param name [Symbol, String] an unique section name
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Node::Finders#all.
        #  (In most cases should be ommited for named sections because the section selector is specified
        #  with `#me` method. But must be specified for anonymous sections)
        # @param options [Hash] original Capybara options. For details, see `Capybara::Node::Finders#all.
        #  (In most cases should be ommited for named sections because the section selector is specified
        #  with `#me` method. But may be specified for anonymous sections)
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
        # @example Anonymous nested section
        #   class HomePage < Howitzer::Web::Page
        #     section :info_panel, '#panel' do
        #       element :edit_button, '.edit'
        #
        #       section :form, '.form' do
        #         element :title_field, '.title'
        #       end
        #     end
        #   end
        #   HomePage.on { info_panel_section.edit_info(title: 'Test Title') }
        # @!visibility public

        def section(name, *args, **options, &block)
          scope = SectionScope.new(name, *args, **options, &block)
          define_section_method(scope.section_class, name, *scope.finder_args, **scope.finder_options)
          define_sections_method(scope.section_class, name, *scope.finder_args, **scope.finder_options)
          define_has_section_method(name, *scope.finder_args, **scope.finder_options)
          define_has_no_section_method(name, *scope.finder_args, **scope.finder_options)
        end

        private

        def define_section_method(klass, name, *args, **options)
          define_method("#{name}_section") do |**block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              klass.new(self, capybara_context.find(*args, **kwdargs))
            else
              klass.new(self, capybara_context.find(*args))
            end
          end
        end

        def define_sections_method(klass, name, *args, **options)
          define_method("#{name}_sections") do |**block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.all(*args, **kwdargs).map { |el| klass.new(self, el) }
            else
              capybara_context.all(*args).map { |el| klass.new(self, el) }
            end
          end
        end

        def define_has_section_method(name, *args, **options)
          define_method("has_#{name}_section?") do |**block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.has_selector?(*args, **kwdargs)
            else
              capybara_context.has_selector?(*args)
            end
          end
        end

        def define_has_no_section_method(name, *args, **options)
          define_method("has_no_#{name}_section?") do |**block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.has_no_selector?(*args, **kwdarg)
            else
              capybara_context.has_no_selector?(*args)
            end
          end
        end
      end
    end
  end
end

require 'howitzer/web/base_section'
