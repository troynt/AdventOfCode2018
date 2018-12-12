class PlantRules
  attr_reader(
    :rules
  )

  def parse_rules(rules)
    rules.strip.split("\n").map {|x| x.split('=>').map(&:strip)}.map {|before, after| [before, after == '#']}.to_h
  end

  def initialize(rules)
    @rules = parse_rules(rules)
  end

  def next_state(state)
    return false if rules[state].nil?

    rules[state]
  end
end