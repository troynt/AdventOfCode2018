require 'memery'

require_relative 'acre'

class SettlersofTheNorthPole
  include Memery

  attr_reader(
    :width,
    :height,
    :land,
    :time,
    :history
  )

  def initialize(io)
    @land = {}
    @time = 0
    @history = []
    y = -1
    @width = nil
    io.each_line do |line|
      y += 1
      line = "*#{line.strip}*"
      @width = line.length
      line.chars.each_with_index do |letter, x|
        coord = xy_to_coord(x, y)
        @land[coord] = Acre.new(letter)
      end
    end
    @height = @land.length / @width
  end

  def xy_to_coord(x, y)
    y * width + x
  end

  memoize def coords_next_to(coord)
    [
      coord - width, # top
      coord - 1 - width, # top left
      coord - 1, # left
      coord - 1 + width, # bottom left
      coord + width, # bottom
      coord + 1 + width, # bottom right
      coord + 1, # right
      coord - width + 1 # top right
    ].freeze
  end

  def neighbors_of(origin)
    coords_next_to(origin).map do |coord|
      @land[coord]
    end.compact
  end

  def to_s
    s = StringIO.new

    (0..height - 1).each do |y|
      char_summary = []
      (0..width - 1).each do |x|
        tile = land[xy_to_coord(x, y)]
        s << tile.to_s
      end
      s << "\n"
    end

    s.string
  end

  def draw(label = nil)
    puts label
    puts to_s
  end

  def decode(str)
    land.each do |coord, _|
      @land[coord] = Acre.new(str[coord])
    end
  end

  def encode
    land.values.map(&:to_s).join("")
  end

  def tree_count
    land.values.count(&:tree?)
  end

  def lumberyard_count
    land.values.count(&:lumberyard?)
  end

  def simulate(count: 1, allow_shortcut: false)
=begin
An open acre will become filled with trees if three or more adjacent acres contained trees. Otherwise, nothing happens.
An acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards. Otherwise, nothing happens.
An acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees. Otherwise, it becomes open.
=end

    count.times do
      land.each do |coord, acre|
        acre_neighbors = neighbors_of(coord)

        lumberyard_count = acre_neighbors.count(&:lumberyard?)
        tree_count = acre_neighbors.count(&:tree?)

        if acre.open? && tree_count >= 3
          acre.next_letter = '|'
        elsif acre.tree? && lumberyard_count >= 3
          acre.next_letter = '#'
        elsif acre.lumberyard? && (lumberyard_count.zero? || tree_count.zero?)
          acre.next_letter = '.'
        end
      end

      land.each do |coord, acre|
        acre.apply_next_letter
      end
      @time += 1
      if allow_shortcut
        key = encode
        cycle_start = @history.index(key)
        if cycle_start
          cycle = @history[cycle_start..(@history.length - 1)]
          cycle_length = cycle.length

          target_idx = (count - time) % cycle_length

          # binding.pry

          decode(cycle[target_idx])
          @time = count
          return
        end


        @history << key
      end



    end
  end

end
