# frozen_string_literal: true

MAX_CELL_POWER = 4
MIN_CELL_POWER = -5
GRID_SIZE = 300

require 'pry'
require 'memery'
require 'parallel'

Coords = Struct.new(:x, :y, :size) do
  def each
    ymax = y + (size - 1)
    xmax = x + (size - 1)

    return enum_for(:each) unless block_given?

    (y..ymax).each do |cy|
      (x..xmax).each do |cx|
        yield cx, cy
      end
    end
  end
end

class ChronalChargeCell
  attr_reader(
    :x,
    :y,
    :grid
  )

  def initialize(grid, x, y)
    @grid = grid
    @x = x
    @y = y
  end

  def grid_serial_num
    grid.serial_num
  end

  def valid?(size = 3)
    !(x + size > GRID_SIZE || y + size > GRID_SIZE)
  end

  def total_value(size = 3)
    grid.total_value_at(x, y, size)
  end

  def value
    return @value if defined? @value

    @value = begin
      calc(x, y)
    end
  end

  def calc(x, y)
    id = x + 10
    ((id * y + grid_serial_num) * id).digits[2] - 5
  end
end

class ChronalCharge
  include Memery

  attr_reader(
    :serial_num,
    :cells,
    :sums,
    :verbose
  )

  def initialize(serial_num, verbose: false)
    @serial_num = serial_num
    @cells = {}
    @sums = {}
    @verbose = verbose
    (1..GRID_SIZE).each do |y|
      @cells[y] = {}
      (1..GRID_SIZE).each do |x|
        @cells[y][x] = ChronalChargeCell.new(self, x, y)
      end
    end
  end

  def total_value_at(x, y, size)
    s = sums[size]

    ymins = s[y - 1]
    ymax = y + size - 1
    ymaxes = s[ymax]
    xmax = x + size - 1

    return ymaxes[xmax] - ymins[xmax] - ymaxes[x - 1] + ymins[x - 1]
  end

  def calc(size = 3)
    calc_sums(size)

    c = @cells.values.map(&:values).flatten.select { |c| c.valid?(size) }.max_by { |c| c.total_value(size) }

    [c.x, c.y, size]
  end

  # https://en.wikipedia.org/wiki/Summed-area_table
  def calc_sums(size)
    sum = Array.new(GRID_SIZE) { Array.new(GRID_SIZE).unshift(0) }
    sum.unshift([0] * (GRID_SIZE + 1))

    Coords.new(1, 1, GRID_SIZE).each do |x, y|
      sum[y] ||= {}
      sum[y][x] = @cells[y][x].value + sum[y - 1][x] + sum[y][x - 1] - sum[y - 1][x - 1]
    end

    @sums[size] = sum
  end

  memoize def max_cell_power(size)
    size * size * MAX_CELL_POWER
  end

  def calc2
    max = nil # [cell, size, value]

    mutex = Mutex.new

    GRID_SIZE.downto(1).each do |x|
      calc_sums(x)
    end

    #Parallel.each((GRID_SIZE.downto(1)).to_a, in_threads: 4) do |size|
    (GRID_SIZE.downto(1).to_a).each do |size|
      time_start = Time.now

      max_possible = max_cell_power(size)

      if !max.nil? && max[2] > max_possible
        puts "skipping #{size}, not possible to beat max" if verbose
        next
      end

      (GRID_SIZE - size).downto(1).each do |y|
        (GRID_SIZE - size).downto(1).each do |x|
          c = @cells[y][x]
          v = total_value_at(x, y, size)
          if max.nil? || max[2] < v
            mutex.synchronize do
              max = [c, size, v]
            end
            break if max[2] >= max_possible
          end
        end
        break if max[2] >= max_possible
      end

      time_done = Time.now

      puts "done with #{size}... took #{((time_done - time_start).to_f * 1000).round} ms" if verbose
    end

    c, size, v = max

    [c.x, c.y, size]
  end
end
