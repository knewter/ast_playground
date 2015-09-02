require 'spec_helper'
require 'ruleset'

RSpec.describe Ruleset do
  let(:ruleset) { Ruleset.new("Foo", [:fake_rule_1, :fake_rule_2]) }

  subject { ruleset }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:rules) }
end
