require_relative 'character'

class Tile
  attr_accessor(
    :pos,
    :character
  )

  attr_writer(
    :letter
  )

  def initialize(pos:, letter:, team_attack_power:)
    self.pos = pos
    case letter
    when 'G', 'E'
      self.character = Character.new(team: letter, tile: self, attack_power: team_attack_power[letter])
      self.letter = '.'
    else
      self.letter = letter
    end
  end

  def x
    pos[0]
  end

  def y
    pos[1]
  end

  def open?
    letter == '.'
  end

  def wall?
    letter == '#'
  end

  def letter
    if character
      character.colorized_team
    else
      @letter
    end
  end

  def to_s
    letter
  end

end
