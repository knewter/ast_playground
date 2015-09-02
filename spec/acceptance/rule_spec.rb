require 'ast'
require 'pry'

module Knewter
  class RuleEvaluator < AST::Processor
    include AST::Sexp

    def evaluate(ast, doc)
      @doc = doc
      process(ast)
    end

    def on_if(node)
      children = process_all(node)

      if children.count == 2 # we have an if, not an if-else
        condition = children[0]
        return_val = children[1]
        if(condition == s(:boolean, true))
          return_val
        end
      end
    end

    def on_contains(node)
      string = node.children[0].children[0]
      if @doc.include?(string)
        s(:boolean, true)
      else
        s(:boolean, false)
      end
    end
  end

  class Rule
    include AST::Sexp

    def initialize(ast)
      @ast = ast
    end

    def eval(doc)
      RuleEvaluator.new.evaluate(@ast, doc)
    end
  end
end

RSpec.describe Knewter::Rule do
  include AST::Sexp

  let(:doc){ "foo bar" }
  let(:bad_doc){ "gimlet" }
  let(:ast){
    s(:if,
      s(:contains, s(:string, "foo")),
      s(:string, "foo")
    )
  }
  it "can be evaluated" do
    rule = Knewter::Rule.new(ast)
    expect(rule.eval(doc)).to eq(s(:string, "foo"))
    expect(rule.eval(bad_doc)).not_to eq(s(:string, "foo"))
  end
end
