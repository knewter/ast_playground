require_relative '../lib/calculator'
include AST::Sexp
expr = s(:add, s(:integer, 2), s(:integer, 2))

p Calculator.new.process(expr)
