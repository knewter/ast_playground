require 'spec_helper'
require 'simple_evaluator'

RSpec.describe SimpleEvaluator do
  let(:evaluator) { SimpleEvaluator.new(:fake_ruleset) }

  subject { evaluator }

  it { is_expected.to respond_to(:ruleset) }
  it { is_expected.to respond_to(:call) }
end
