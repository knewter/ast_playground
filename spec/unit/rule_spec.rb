require 'spec_helper'
require 'ast'
require 'rule'
require 'pry'

RSpec.describe Rule do
  include AST::Sexp

  let(:rule) { Rule.new("BMI Over 40", test_ast) }

  context "interface" do
    let(:test_ast) { {foo: "Bar"} }
    subject { rule }

    it { is_expected.to respond_to(:ast) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:source) }
  end

  context "with a nested :if node" do
    let(:test_ast) do
      {if: [
        {contains: {name: "patient"}},
        {if: [
            {contains: {name: "bmi"}},
            {string: "BMI was found"}
        ]}
      ]}
    end

    it "compiles its AST input" do
      expected_ast =
        s(:if,
          s(:contains, s(:name, "patient")),
          s(:if,
            s(:contains, s(:name, "bmi")),
            s(:string, "BMI was found")))

      expect( rule.ast ).to eq(expected_ast)
    end
  end

  context "with an empty node in the source" do
    let(:test_ast) { {if: [{contains: {name: "patient"}}, {}]} }

    it "returns an :empty node" do
      expected_ast =
        s(:if,
          s(:contains, s(:name, "patient")),
          s(:empty))

      expect( rule.ast ).to eq(expected_ast)
    end
  end

  context "with singletons in the source" do
    let(:test_ast) { {if: [true, {if: [false, {string: "You will NEVER get here!"}]}]} }

    it "handles singleton nodes" do
      expected_ast =
        s(:if, s(:true),
          s(:if, s(:false),
            s(:string, "You will NEVER get here!")))

      expect( rule.ast ).to eq(expected_ast)
    end
  end
end
