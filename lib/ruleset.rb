class Ruleset
  attr_reader :name, :rules

  def initialize(name, rules)
    @name = name
    @rules = rules || []
  end
end
