require 'byebug'

LOCATOR = [:xpath, ->(a, b) { "#{a}:#{b}" }, :css, ->(c) { "hrew#{c}" }].freeze
def foo(*params)
  convert_arguments(LOCATOR, params)
end

def convert_arguments(args, params)
  hash = params.pop if params.last.is_a?(Hash)
  args.map! do |el|
    next(el) unless el.is_a?(Proc)
    el.call(*params.shift(el.arity))
  end
  args << hash unless hash.nil?
  args
end

p foo(1, 2, 3, wait: true)
