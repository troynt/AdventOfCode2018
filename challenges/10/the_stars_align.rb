# frozen_string_literal: true

require_relative 'star'

class TheStarsAlign
  attr_accessor(
    :stars
  )

  def initialize(stars)
    @stars = stars
  end

  def step(time = 1)
    stars.map { |s| s.step(time) }
  end

  def step_until_aligned
    steps_required = 0
    prev_y_length = 1.0 / 0
    loop do
      step
      cur_y_length = y_length
      if prev_y_length < cur_y_length
        step(-1)
        break
      end
      steps_required += 1
      prev_y_length = cur_y_length
    end

    steps_required
  end

  def y_length
    ymin, ymax = y_range
    ymax - ymin
  end

  def y_range
    stars.minmax_by(&:y).map(&:y)
  end

  def x_range
    stars.minmax_by(&:x).map(&:x)
  end

  def draw
    xmin, xmax = x_range
    ymin, ymax = y_range

    puts ""
    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
        found = @stars.any? { |s| s.x == x && s.y == y }
        if found
          print '#'
        else
          print '.'
        end
      end

      puts ''
    end
  end
end
