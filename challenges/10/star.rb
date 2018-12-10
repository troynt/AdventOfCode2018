class Star
  attr_accessor(
    :pos,
    :vel
  )

  def initialize(pos:, vel:)

    @pos = pos
    @vel = vel
  end

  def x
    pos[0]
  end

  def y
    pos[1]
  end

  def step(time = 1)
    @pos = pos.zip(vel.map { |x| x * time}).map(&:sum)
  end

  def self.init_from_str(str)
    _, pos, vel = str.match(/position=<(.+)> velocity=<(.+)>/).to_a

    pos = pos.split(',', 2).map(&:to_i)
    vel = vel.split(',', 2).map(&:to_i)

    new(pos: pos, vel: vel)

  end
end