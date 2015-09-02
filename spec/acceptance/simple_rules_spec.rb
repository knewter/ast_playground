require 'spec_helper'
require 'json'
require 'simple_evaluator'

RSpec.describe "Simplest Rules with a single condition" do
  include AST::Sexp

  let(:evaluator) { SimpleEvaluator.new(ruleset) }
  let(:ruleset) { Ruleset.new("Simple", [rule]) }
  let(:rule) { Rule.new("True or False", ast) }

  context "when the source AST's :if node's condition is truthy" do
    let(:ast) { {if: [true, {string: "TRUE"}, {string: "FALSE"}]} }

    it "returns the result of processing its 'then' expression" do
      expect( evaluator.call ).to eq([s(:string, "TRUE")])
    end
  end

  context "when the source AST's if node's condition is falsey" do
    let(:ast) { {if: [false, {string: "TRUE"}, {string: "FALSE"}]} }

    it "returns the result of processing its 'else' expression" do
      expect( evaluator.call ).to eq([s(:string, "FALSE")])
    end
  end
end
