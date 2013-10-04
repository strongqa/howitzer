#The following are locator aliases:
#
#1) locator
#Type: :css(by default), :xpath
#Method example: find, all, first
#
#2) link_locator
#Type: id, text
#Method example: click_link, find_link
#
#3) button_locator
#Type: id, name, value
#Method example: click_button, find_button
#
#4) field_locator
#Type: name, id, text
#Method example: find_field, fill_in


module LocatorStore
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    class BadLocatorParamsError < StandardError; end
    class LocatorNotSpecifiedError < StandardError; end

    def add_locator(name, params)
      add_locator_by_type(:base, name, params)
    end

    def add_link_locator(name, params)
      add_locator_by_type(:link, name, params)
    end


    def add_field_locator(name, params)
      add_locator_by_type(:field, name, params)
    end

    def add_button_locator(name, params)
      add_locator_by_type(:button, name, params)
    end

    def locator(name)
      locator_by_type(:base, name)
    end

    def link_locator(name)
      locator_by_type(:link, name)
    end

    def field_locator(name)
      locator_by_type(:field, name)
    end

    def button_locator(name)
      locator_by_type(:button, name)
    end


    def apply(locator, *values)
      locator.call(*values).to_a.flatten
    end

    protected

    def parent_locator(type, name)
      if !@locators.nil? && @locators.key?(self.name) && @locators[self.name].key?(type) && @locators[self.name][type].key?(name)
        @locators[self.name][type][name]
      else
        self.superclass.parent_locator(type, name) unless self.superclass == Object
      end
    end

    private

    def locator_by_type(type, name)
      locator = parent_locator(type, name)
      raise(LocatorNotSpecifiedError, name) if locator.nil?
      locator
    end

    def add_locator_by_type(type, name, params)
      @locators ||= {}
      @locators[self.name] ||= {}
      @locators[self.name][type] ||= {}
      raise BadLocatorParamsError, args.inspect if params.nil? || (!params.is_a?(Proc) && params.empty?)
      case params.class.name
        when 'Hash'
          @locators[self.name][type][name] = [params.keys.first.to_sym, params.values.first.to_s]
        when 'Proc'
          @locators[self.name][type][name] = params
        else
          @locators[self.name][type][name] = params.to_s
      end
    end
  end

  def locator(name)
    self.class.locator(name)
  end

  def link_locator(name)
    self.class.link_locator(name)
  end

  def field_locator(name)
    self.class.field_locator(name)
  end

  def button_locator(name)
    self.class.button_locator(name)
  end

  def apply(locator, *values)
    self.class.apply(locator, *values)
  end
end