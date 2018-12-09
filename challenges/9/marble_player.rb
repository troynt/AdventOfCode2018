class MarblePlayer
  attr_reader(
    :name
  )

  attr_accessor(
    :score
  )

  def initialize(name)
    @score = 0
    @name = name
  end

  def to_s
    "P#{name} (#{score})"
  end
end