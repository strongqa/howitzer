class Section
  def self.element(*args)
    puts '_____HELLO____'
    p args
    puts '______BYE_____'
  end

  def check
    puts 2
  end
end

class SectionScope
  attr_accessor :section_class
  def initialize(&block)
    self.section_class = Class.new(Section)
    instance_eval(&block)
  end

  def element(*args)
    section_class.element(*args)
  end
end

module SectionDSL
  def section(name, &block)
    scope = SectionScope.new(&block)

    define_method("#{name}_section") do
      scope.section_class.new
    end
  end
end

class Foo
  extend SectionDSL

  section :hello do
    element :bar, :id, 'my_id'
  end
end

Foo.new.hello_section.check
