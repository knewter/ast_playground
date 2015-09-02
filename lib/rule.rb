require 'ast'

class Rule
  include AST::Sexp

  attr_reader :name, :source

  def initialize(name, source)
    @name = name
    @source = source
  end

  def ast
    @ast ||= assemble(source)
  end

  private

  def assemble(source)
    case source
    when Enumerable
      source.reduce(s(:empty)) do |ast, (type, children)|
        next s(type, children) unless children.respond_to?(:map)
        s(type, *[children].flatten.map { |child| assemble(child) })
      end
    when true, false, nil
      s(source.to_s)
    else
      s(:unrecognized)
    end
  end
end
