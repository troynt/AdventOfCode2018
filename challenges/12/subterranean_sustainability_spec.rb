# frozen_string_literal: true
require_relative 'subterranean_sustainability'

describe 'SubterraneanSustainability' do
  EXAMPLE_RULES = """...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #"""


  it 'should be able to read the rules' do
    r = PlantRules.new(EXAMPLE_RULES)
    expect(r.rules.length).to eq(14)

    expect(r.rules["..#.."]).to be(true)
    expect(r.rules["#####"]).to be(nil)

    expect(r.next_state("..#..")).to be(true)
  end

  it 'should be able to fetch neighbors' do
    s = SubterraneanSustainability.new("##.##", EXAMPLE_RULES)

    expect(s.pots.to_a[0].state).to eq(true)
    expect(s.pots.to_a[2].state).to eq(false)

    expect(s.pots.to_a[2].self_with_neighbors.map(&:state)).to eq(s.pots.map(&:state))

    expect(s.to_i).to eq(0 + 1 + 3 + 4)

    expect(PlantPot.new(true).state_with_neighbors).to eq("..#..")

  end


  it 'should be able to fetch neighbors even when pots are missing' do
    s = SubterraneanSustainability.new("#.", EXAMPLE_RULES)

    expect(s.pots.first.state_with_neighbors).to eq('..#..')

  end


  it 'should be able to calculate proper sum' do
    example = ".#....##....#####...#######....#.#..##."
    s = SubterraneanSustainability.new(example, EXAMPLE_RULES)

    s.pots.each_with_index do |p, i|
      p.location = i - 3
    end

    expect(example.length).to eq(s.pots.to_a.length)


    expect(s.to_i).to eq(325)
  end


  it 'should be able to transition plant state' do
    final_state = ".#....##....#####...#######....#.#..##."
    s = SubterraneanSustainability.new("#..#.#..##......###...###", EXAMPLE_RULES)

    expect(s.step(20, verbose: false)).to eq(325)

  end

  it 'should be able to calculate solution' do

    s = SubterraneanSustainability.new(".##.##...#.###..#.#..##..###..##...####.#...#.##....##.#.#...#...###.........##...###.....##.##.##", """##... => .
#...# => .
.###. => #
.##.# => #
#.... => .
..##. => #
##..# => #
.#... => #
.#.## => #
#.### => #
.#..# => .
##.#. => #
..#.. => .
.##.. => #
###.# => .
.#### => .
##### => .
#.#.. => #
...## => #
...#. => .
###.. => .
..... => .
#.#.# => .
##.## => #
#.##. => #
####. => #
#..#. => #
.#.#. => .
#..## => #
....# => .
..#.# => #
..### => .""")

    expect(s.step(20, verbose: false)).to eq(1184)
  end

  it 'should be able to calculate solution part 2' do

    s = SubterraneanSustainability.new(".##.##...#.###..#.#..##..###..##...####.#...#.##....##.#.#...#...###.........##...###.....##.##.##", """##... => .
#...# => .
.###. => #
.##.# => #
#.... => .
..##. => #
##..# => #
.#... => #
.#.## => #
#.### => #
.#..# => .
##.#. => #
..#.. => .
.##.. => #
###.# => .
.#### => .
##### => .
#.#.. => #
...## => #
...#. => .
###.. => .
..... => .
#.#.# => .
##.## => #
#.##. => #
####. => #
#..#. => #
.#.#. => .
#..## => #
....# => .
..#.# => #
..### => .""")

    expect(s.step(50_000_000_000, verbose: false)).to eq(250000000219)
  end


end
