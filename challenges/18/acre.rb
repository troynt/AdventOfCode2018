class Acre

  attr_reader(
    :letter
  )

  attr_accessor(
    :next_letter
  )

  def open?
    letter == '.'
  end

  def tree?
    letter == '|'
  end

  def lumberyard?
    letter == '#'
  end

  def initialize(letter)
    @letter = letter
  end

  def to_s
    letter
  end

  def apply_next_letter
    unless next_letter.nil?
      @letter = next_letter
      @next_letter = nil
    end
  end
end