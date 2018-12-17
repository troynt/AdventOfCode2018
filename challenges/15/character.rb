# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'colorize'

class Character
  include Memery

  @@id = 0

  attr_accessor(
    :hp,
    :team,
    :pos
  )

  attr_reader(
    :tile,
    :attack_power,
    :id
  )

  delegate(
    :pos,
    to: :tile
  )

  def initialize(team:, tile:, hp: 200, attack_power: 3)
    @id = @@id += 1
    @hp = hp
    @attack_power = attack_power
    @team = team
    @tile = tile
  end

  memoize def enemy_of?(char)
    team != char.team
  end

  def tile=(new_tile)
    new_tile.character = self
    @tile.character = nil
    @tile = new_tile
  end

  def colorized_id
    colorized(id.to_s)
  end

  def colorized_team
    colorized(team)
  end

  def colorized(label)
    if elf?
      label.green.bold
    else
      label.red.bold
    end
  end

  def alive?
    hp.positive?
  end

  def attack(char)
    unless alive?
      raise 'Unable to attack while dead.'
    end

    char.take_damage(attack_power)
  end

  def take_damage(damage)
    @hp -= damage
    unless alive?
      tile.character = nil # remove character from map if dead
    end
  end

  def to_s
    "#{team}#{id}(#{hp})"
  end

  memoize def enemy_team
    {
      'E' => 'G',
      'G' => 'E'
    }[team]
  end

  memoize def elf?
    team == 'E'
  end

  memoize def goblin?
    team == 'G'
  end
end
