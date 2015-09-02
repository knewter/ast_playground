require 'spec_helper'
require 'ast'
require 'rule'

RSpec.describe Rule do
  include AST::Sexp

  let(:rule) { Rule.new("BMI Over 40", test_source) }

  describe "interface" do
    let(:test_source) { {foo: "Bar"} }
    subject { rule }

    it { is_expected.to respond_to(:ast) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:source) }
  end


  describe "assembling AST" do
    context "with invalid source" do
      let(:test_source) { "foobar" }
      it "assigns an :empty node to its AST" do
        expect( rule.ast ).to eq(s(:unrecognized))
      end
    end


    context "with a nested :if in the source" do
      let(:test_source) {
        {if: [
          {contains: {name: "patient"}},
          {if: [
              {contains: {name: "bmi"}},
              {string: "BMI was found"} ]} ]}
      }
      let(:expected_ast) {
        s(:if,
          s(:contains, s(:name, "patient")),
          s(:if,
            s(:contains, s(:name, "bmi")),
            s(:string, "BMI was found")))
      }

      it "assembles its AST input correctly" do
        expect( rule.ast ).to eq(expected_ast)
      end
    end


    context "with an empty element in the source" do
      let(:test_source) { {if: [{contains: {name: "patient"}}, {}]} }
      let(:expected_ast) {
        s(:if, s(:contains, s(:name, "patient")), s(:empty))
      }

      it "replaces the empty element with an :empty node" do
        expect( rule.ast ).to eq(expected_ast)
      end
    end


    context "with singletons in the source" do
      let(:test_source) {
        {if: [true, {if: [false, {string: "You will NEVER get here!"}]} ]}
      }
      let(:expected_ast) {
          s(:if, s(:true),
            s(:if, s(:false),
              s(:string, "You will NEVER get here!")))
      }

      it "assembles an appropriate singleton node" do
        expect( rule.ast ).to eq(expected_ast)
      end
    end
  end
end
