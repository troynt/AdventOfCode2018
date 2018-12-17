# frozen_string_literal: true

require 'memery'

require_relative 'tile'

require 'pry'

def pause
  a = STDIN.gets
end

class BeverageBandit
  include Memery

  attr_reader(
    :board,
    :characters,
    :width,
    :height
  )

  def initialize(io, team_attack_power: { "G" => 3, "E" => 3})
    @characters = []
    @board = {}
    y = -1
    @width = nil
    io.each_line do |line|
      y += 1
      @width = line.strip.length
      line.strip.chars.each_with_index do |letter, x|
        coord = xy_to_coord(x, y)
        t = Tile.new(pos: coord, letter: letter, team_attack_power: team_attack_power)
        @characters << t.character if t.character
        @board[coord] = t
      end
    end
    @height = @board.length / @width
  end

  def xy_to_coord(x, y)
    y * width + x
  end

  def draw(label = nil)
    puts label
    puts to_s
  end

  def to_s
    s = StringIO.new

    (0..height - 1).each do |y|
      char_summary = []
      (0..width - 1).each do |x|
        tile = board[xy_to_coord(x, y)]
        s << tile.to_s
        if tile.character
          char_summary << tile.character.to_s
        end
      end
      s << "\t" + char_summary.join(', ')
      s << "\n"
    end
    
    s.string
  end

  memoize def coords_next_to(coord)
    [
      coord - width, # top
      coord - 1, # left
      coord + 1, # right
      coord + width # bottom
    ].freeze
  end

  def neighbors_of(origin)
    coords_next_to(origin).map do |coord|
      @board[coord]
    end.compact.reject(&:wall?)
  end

  def adj_enemies_of(char)
    neighbors_of(char.pos).select { |x| x.character && char.alive? && char.enemy_of?(x.character) }.map(&:character)
  end

  def each
    return enum_for(:each) unless block_given?

    board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        yield [x, y], tile
      end
    end
  end

  def path_of(came_from, n)
    path = [n]
    current = n
    while (prev = came_from[current])
      path.unshift(prev)
      current = prev
    end
    path
  end

  def bfs(start:, neighbors:, goal:)
    frontier = [start]
    came_from = { frontier => nil }
    goals = []

    until frontier.empty?
      next_frontier = []
      while (next_coord = frontier.shift)
        goals << next_coord if goal.include? next_coord

        next unless goals.empty?

        neighbors[next_coord].each do |neigh|
          next if came_from.key?(neigh)

          came_from[neigh] = next_coord
          next_frontier << neigh
        end
      end
      frontier = next_frontier if goals.empty?
    end

    goals.empty? ? nil : path_of(came_from, goals.min)
  end

  def battle(verbose: false, wait: false, return_alive_chars: false, max_elf_deaths: 1.0/0)
    rounds = 0
    loop do
      characters.sort_by!(&:pos)
      alive_chars = characters.select(&:alive?)
      alive_chars_by_team = alive_chars.group_by(&:team)
      last_char = alive_chars.last


      puts alive_chars.map(&:to_s).join(", ") if verbose

      cur_elf_deaths = 0

      alive_chars.each_with_index do |char, char_idx|
        next unless char.alive?

        adj_enemies = adj_enemies_of(char)
        if adj_enemies.empty?

          path = bfs(
            start: char.pos,
            neighbors: lambda { |pos|
              neighbors_of(pos).select(&:open?).map(&:pos)
            },
            goal: Set.new(alive_chars_by_team[char.enemy_team].flat_map do |e|
              neighbors_of(e.pos).map(&:pos)
            end)
          )

          unless path
            puts "unable to find path for #{char}" if verbose
            next
          end

          puts "#{char} will now move to #{path[1]} (want to go to #{path[-1]})" if verbose

          char.tile = board[path[1]]
          adj_enemies = adj_enemies_of(char)
        end

        next if adj_enemies.empty?

        # attack
        target = adj_enemies.min_by { |x| [x.hp, x.pos] }
        char.attack(target)
        puts "#{char} is attacking #{target}" if verbose
        next if target.alive?

        alive_chars = characters.select(&:alive?)
        alive_chars_by_team = alive_chars.group_by(&:team)

        puts "#{target} died." if verbose

        cur_elf_deaths += 1 if target.elf?

        if cur_elf_deaths >= max_elf_deaths || alive_chars_by_team[target.team].nil? || alive_chars_by_team[target.team].empty?
          rounds += 1 if last_char == char
          if return_alive_chars
            return [rounds, characters.select(&:alive?).map(&:hp).sum, alive_chars_by_team]
          else
            return [rounds, characters.select(&:alive?).map(&:hp).sum]
          end
        end

        last_char = alive_chars.last
      end
      rounds += 1

      draw(rounds) if verbose
      pause if wait
    end
  end
end
##
#