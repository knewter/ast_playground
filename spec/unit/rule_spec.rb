require 'spec_helper'
require 'ast'
require 'rule'

RSpec.describe Rule do
  include AST::Sexp

  let(:rule) { Rule.new("BMI Over 40", test_ast) }

  let(:test_ast) do
    {if: [
      {contains: {object: "patient"}},
      {if: [
          {contains: {object: "bmi"}},
          {string: "BMI was found"}
      ]}
    ]}
  end

  subject { rule }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:ast) }
  it { is_expected.to respond_to(:raw) }

  it "compiles its AST input" do
    expected_ast =
      s(:if,
        s(:contains, s(:object, "patient")),
        s(:if,
          s(:contains, s(:object, "bmi")),
          s(:string, "BMI was found")))

    expect( rule.ast ).to eq(expected_ast)
  end
end
