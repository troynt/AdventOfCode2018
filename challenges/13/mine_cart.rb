# frozen_string_literal: true

require_relative 'mine_cart_crash_exception'
require 'pry'
require 'colorize'

class MineCart
  @@id = 0
  DIRS = { up: '^', right: '>', left: '<', down: 'v' }.freeze
  CHARS_TO_DIRS = DIRS.invert

  attr_accessor(
    :dir,
    :dir_cycle,
    :track
  )

  attr_reader(
    :id
  )

  def self.init_from_char(char)
    new(CHARS_TO_DIRS[char]) unless CHARS_TO_DIRS[char].nil?
  end

  def track=(new_track)
    track.contains = nil unless track.nil?

    if new_track.nil?
      @track = nil
    else
      new_track.contains = self
      if new_track.diag?
        # /-\
        # | |
        # \-/
        new_dir = dir
        if new_track.type == :rdiag
          new_dir = { right: :up, down: :left, up: :right, left: :down }[dir]
        elsif new_track.type == :ldiag
          new_dir = { left: :up, down: :right, up: :left, right: :down }[dir]
        end
        self.dir = new_dir unless new_track.send(new_dir).nil?
      end
      @track = new_track
    end
  end

  def x
    track.x
  end

  def y
    track.y
  end

  attr_writer :crashed

  def crashed?
    @crashed == true
  end

  def operational?
    !crashed?
  end

  def initialize(dir)
    @dir = dir
    @dir_cycle = %i[left straight right].cycle
    @id = @@id += 1
    @crashed = false
  end

  # turn_dir can be :straight, :left, :right
  def turn(turn_dir)
    return if turn_dir == :straight

    @dir = case dir
           when :up
             turn_dir
           when :down
             { left: :right, right: :left }[turn_dir]
           when :right
             { left: :up, right: :down }[turn_dir]
           when :left
             { left: :down, right: :up }[turn_dir]
    end
  end

  def tick
    return if crashed?

    next_track = track.send(dir)

    if next_track.nil?
      self.crashed = true
      raise MineCartCrashException.new(track: track, cart: self)
    end

    if next_track.occupied?
      other_cart = next_track.contains
      other_cart.crashed = true

      self.crashed = true

      self.track = nil

      raise MineCartCrashException.new(track: next_track, cart: self)
    else
      self.track = next_track
      if track.type == :inter
        new_dir = dir_cycle.next
        turn(new_dir)
      end
    end
  end

  def to_s
    if @crashed
      '*'.red.bold
    else
      DIRS[dir].green.bold
    end
  end
end
