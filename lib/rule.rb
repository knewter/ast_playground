require 'ast'

class Rule
  extend AST::Sexp

  attr_reader :name, :raw

  def initialize(name, raw_ast)
    @name = name
    @raw = raw_ast
  end

  def ast
    @ast ||= self.class.assemble(raw)
  end


  def self.assemble(node)
    node.reduce(nil) do |ast, (type, children)|
      next s(type, children) unless children.respond_to?(:map)
      s(type, *[children].flatten.map { |child| assemble(child) })
    end
  end
end
