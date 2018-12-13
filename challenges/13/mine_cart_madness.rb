require_relative "./mine_track"
require_relative "./mine_cart"
require_relative "./mine_cart_crash_exception"

require 'pry'


class MineCartMadness
  attr_reader(
    :tracks,
    :carts,
    :xmin,
    :xmax,
    :ymin,
    :ymax
  )



  def initialize(track_str)
    prev_line = nil

    @tracks = {}
    @carts = []
    @xmin = @ymin = 0

    track_str.split("\n").each_with_index do |line, y|
      @tracks[y] ||= {}

      line.chars.each_with_index do |char, x|
        unless char.strip.empty?
          t = MineTrack.new(char, x, y)
          c = MineCart.init_from_char(char)
          if c
            @carts << c
            c.track = t
          end

          @tracks[y][x] = t

          u = (@tracks[y-1] || {})[x]
          l = @tracks[y][x-1]

          unless u.nil?
            t.up = u if [:vert, :inter, :ldiag, :rdiag].include?(u.type)
          end

          unless l.nil?
            t.left = l if [:hor, :inter, :ldiag, :rdiag].include?(l.type)
          end

          @xmax = x if @xmax.nil? || x > @xmax
          @ymax = y if @ymax.nil? || y > @ymax
        end
      end
    end
  end

  def sorted_carts
    @carts.sort_by! {|a| [a.y, a.x] }
  end

  def tick_and_clean(&block)
    q = sorted_carts.dup

    while c = q.shift
      next if c.crashed?

      begin
        c.tick
      rescue MineCartCrashException => e
        yield if block_given?
        
        @carts.delete_if { |x| [e.cart, e.track.contains].include?(x) }
        e.track.contains = nil
      end
    end
  end

  def tick
    sorted_carts.map(&:tick)
  end

  def clear_draw
    s = to_s
    system("clear")
    puts s
  end

  def draw
    border_size = (xmax + 5)
    puts "~" * border_size
    print to_s
    puts "~" * border_size
  end

  def to_s
    str = ""

    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
        if tracks[y][x].nil?
          str << " "
        else
          str << tracks[y][x].to_s
        end
      end
      str << "\n"
    end


    str
  end
end
