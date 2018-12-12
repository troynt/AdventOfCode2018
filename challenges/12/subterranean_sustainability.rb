# frozen_string_literal: true

require_relative 'plant_rules'
require_relative 'plant_pot'


class SubterraneanSustainability
  attr_reader(
    :rules,
    :pot_zero,
    :first,
    :last
  )
  def initialize(plants, rules)
    @rules = PlantRules.new(rules)
    p_arr = plants.strip.chars.map do |x|
      PlantPot.new(x == '#')
    end

    p_arr.each_with_index do |p, i|
      p.location = i
      p.prev = p_arr[i - 1] if i - 1 >= 0
      p.next = p_arr[i + 1] if i + 1 < p_arr.length
    end

    @pot_zero = p_arr.first
    @first = p_arr.first
    @last = p_arr.last
  end

  def pots
    Enumerator.new do |y|
      p = @first
      while p
        y.yield p
        p = p.next
      end
    end
  end

  def pot_count
    (@last.location - @first.location).abs
  end

  def state
    pots.join('')
  end

  def to_i
    pots.select(&:has_plant?).map(&:location).sum
  end

  def to_s
    pots.map(&:to_s).join('')
  end

  def draw(label = '')
    print label
    print to_s
    puts
  end

  def unshift_plant
    p = first

    c = PlantPot.new(false, location: p.location - 1)
    c.next = p
    p.prev = c
    @first = c
  end


  def append_plant
    p = last
    c = PlantPot.new(false, location: p.location + 1)
    c.prev = p
    p.next = c
    @last = c
  end

  # can only expand by max of 2 on either side
  def pad_plants
    2.times { unshift_plant }
    2.times { append_plant }
  end

  def step(times = 1, verbose: false, max_unchanged_generations: 100)

    puts rules.rules.inspect if verbose

    puts if verbose
    pad_plants
    draw('S: ') if verbose


    unchanged_rounds = 0

    prev_changes_count = 0
    prev_sum = 0
    delta = 0
    times.times do |gen|
      pad_plants

      pots.each do |p|
        p.next_state = rules.next_state(p.state_with_neighbors)
      end

      change_count = 0

      pots.each do |p|
        next if p.next_state.nil? || p.state == p.next_state

        change_count += 1
        p.state = p.next_state
        p.next_state = nil
      end

      if prev_changes_count == change_count
        unchanged_rounds += 1
      else
        prev_changes_count = change_count
        unchanged_rounds = 0
      end

      cur_sum = to_i
      delta = cur_sum - prev_sum

      prev_sum = cur_sum

      puts "gen #{gen}; changes made #{change_count}; pots #{pot_count}; unchanged rounds #{unchanged_rounds}" if verbose
      draw("#{gen + 1}: ") if verbose

      if unchanged_rounds > max_unchanged_generations
        return prev_sum + (delta * (times - (gen + 1)))
      end
    end

    prev_sum
  end
end
