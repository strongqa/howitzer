require 'howitzer/exceptions'

# The following are locator aliases:
#
# 1) locator
# Type: :css(by default), :xpath
# Method example: find, all, first
#
# 2) link_locator
# Type: id, text
# Method example: click_link, find_link
#
# 3) button_locator
# Type: id, name, value
# Method example: click_button, find_button
#
# 4) field_locator
# Type: name, id, text
# Method example: find_field, fill_in

module LocatorStore
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    LOCATOR_TYPES = [:base, :link, :field, :button]

    ##
    #
    # Adds css or xpath locator into LocatorStore.
    # Also locator can be set by lambda expression. For example: lambda{|name|{xpath: ".//a[@id='#{name}']"}}
    #
    # *Parameters:*
    # * +name+ - Locator name
    # * +params+ - String for css locator or hash with :xpath key and string value for xpath locator
    #

    def add_locator(name, params)
      add_locator_by_type(:base, name, params)
    end

    ##
    #
    # Adds locator for link into LocatorStore. Link can be found by: id, text
    # Capybara methods that can work with this locator type are: click_link, find_link
    #
    # *Parameters:*
    # * +name+ - Locator name
    # * +params+ - ID or text of link
    #

    def add_link_locator(name, params)
      add_locator_by_type(:link, name, params)
    end

    ##
    #
    # Adds locator for field into LocatorStore. Field can be found by: name, id, text
    # Capybara methods that can work with this locator type are: find_field, fill_in
    #
    # *Parameters:*
    # * +name+ - Locator name
    # * +params+ - Name, ID or text of field
    #

    def add_field_locator(name, params)
      add_locator_by_type(:field, name, params)
    end

    ##
    #
    # Add locator for button into LocatorStore. Button can be found by: id, name, value
    # Capybara methods that can work with this locator type are: click_button, find_button
    #
    # *Parameters:*
    # * +name+ - Locator name
    # * +params+ - Name, ID or value
    #

    def add_button_locator(name, params)
      add_locator_by_type(:button, name, params)
    end

    ##
    #
    # Takes css or xpath locator from LocatorStore by name
    #
    # *Parameters:*
    # * +name+ - Locator name
    #

    def locator(name)
      locator_by_type(:base, name)
    end

    ##
    #
    # Take link locator from LocatorStore by name
    #
    # *Parameters:*
    # * +name+ - Locator name
    #

    def link_locator(name)
      locator_by_type(:link, name)
    end

    ##
    #
    # Take field locator from LocatorStore by name
    #
    # *Parameters:*
    # * +name+ - Locator name
    #

    def field_locator(name)
      locator_by_type(:field, name)
    end

    ##
    #
    # Take button locator from LocatorStore be name
    #
    # *Parameters:*
    # * +name+ - Locator name
    #

    def button_locator(name)
      locator_by_type(:button, name)
    end

    ##
    #
    # Get locator set by lambda.
    # For example: find(apply(locator(:locator_name), 'register')).click
    #
    # *Parameters:*
    # * +locator+ - Locator set with lambda expression
    # * +values+ - Arguments that should be matched lambda expression params
    #

    def apply(locator, *values)
      locator.call(*values).to_a.flatten
    end

    def find_element(name)
      type, locator = find_locator(name)
      if type == :base
        send :find, locator
      else
        send "find_#{type}", locator
      end
    end

    def first_element(name)
      type, locator = find_locator(name)
      if type == :base
        send :first, locator
      else
        send :first, type, locator
      end
    end

    protected

    def find_locator(name)
      name = name.to_s.to_sym
      LOCATOR_TYPES.each do|type|
        return [type, locator_by_type(type, name)] if (@locators || {}).fetch(self.name, {}).fetch(type, {})[name]
      end
      log.error(Howitzer::LocatorNotDefinedError, name)
    end

    # looks up locator in current and all super classes
    def parent_locator(type, name)
      if (@locators || {}).fetch(self.name, {}).fetch(type, {}).key?(name)
        @locators[self.name][type][name]
      else
        superclass.parent_locator(type, name) unless superclass == Object
      end
    end

    private

    def locator_by_type(type, name)
      locator = parent_locator(type, name)
      log.error(Howitzer::LocatorNotDefinedError, name) if locator.nil?
      locator
    end

    def add_locator_by_type(type, name, params)
      @locators ||= {}
      @locators[self.name] ||= {}
      @locators[self.name][type] ||= {}
      @locators[self.name][type][name] = build_locator_by_type(params)
    end

    def build_locator_by_type(params)
      validate_locator_params(params)

      case params.class.name
        when 'Hash'
          [params.keys.first.to_s.to_sym, params.values.first.to_s]
        when 'Proc'
          params
        else
          params.to_s
      end
    end

    def validate_locator_params(params)
      log.error Howitzer::BadLocatorParamsError, args.inspect if params.nil? || (!params.is_a?(Proc) && params.empty?)
    end
  end

  # delegate class methods to instance
  ClassMethods.public_instance_methods.each do |name|
    define_method(name) do |*args|
      self.class.send(name, *args)
    end
  end
end
