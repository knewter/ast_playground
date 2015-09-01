require_relative '../lib/arithmetics_processor'
include AST::Sexp
expr = s(:add, s(:integer, 2), s(:integer, 2))

p ArithmeticsProcessor.new.process(expr) == expr # => true
