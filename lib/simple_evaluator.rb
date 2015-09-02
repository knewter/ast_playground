require 'ast'
require 'rule'
require 'ruleset'

class SimpleEvaluator
  include AST::Sexp
  include AST::Processor::Mixin

  attr_reader :ruleset

  def initialize(ruleset)
    @ruleset = ruleset
  end

  def call
    ruleset.rules.map { |rule| process(rule.ast) }
  end

  def on_if(node)
    boolean_expr, then_expr, else_expr = process_all(node)

    if boolean_expr == s(:true)
      then_expr
    else
      else_expr
    end
  end
end
