
Point = Struct.new(:x, :y) do
  def manhattan_dist(pt)
    (pt.x - x).abs + (pt.y - y).abs
  end

  def ==(obj)
    x == obj.x && y == obj.y
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class Location < Point
  attr_accessor :points
  attr_accessor :is_finite
  attr_accessor :label

  def initialize(x, y)
    super
    @points = []
    @is_finite = false
  end

  def label
    @label || "Loc"
  end

  def bb
    @bb ||= BoundingBox.new(points)
  end

  def to_s
    "#{label} (#{x}, #{y}), Finite: #{is_finite}, Area: #{@points.length}"
  end
end

class BoundingBox
  attr_reader :tl, :br

  def initialize(points)
    tl_x = nil
    tl_y = nil

    br_x = nil
    br_y = nil
    
    points.each do |l|
      tl_x = tl_x.nil? ? l.x : [tl_x, l.x].min
      tl_y = tl_y.nil? ? l.y : [tl_y, l.y].min

      br_x = br_x.nil? ? l.x : [br_x, l.x].max
      br_y = br_y.nil? ? l.y : [br_y, l.y].max
    end

    @tl = Point.new(tl_x, tl_y)
    @br = Point.new(br_x, br_y)
  end

  def to_s
    "[#{@tl.to_s}, #{@br.to_s}]"
  end

  def each_point
    (@tl.y..@br.y).each do |y|
      (@tl.x..@br.x).each do |x|
        yield Point.new(x, y)
      end
    end
  end
end

class Six

  attr_reader :tl_pt
  attr_reader :br_pt

  attr_reader :locations
  attr_reader :bb # bounding box 

  def initialize(filepath)
      idx = 0
      @locations = File.open(filepath).readlines.map do |line|
        x, y = line.strip.split(',').map(&:to_i)
        l = Location.new(x, y)
        l.label= (idx + 65).chr
        idx += 1
        l
      end
      @bb = BoundingBox.new(@locations)
  end

  def calc(verbose = true)
    last_y = nil
    puts "" if verbose

    @bb.each_point do |pt|
      min_locs = []
      min_d = nil
      @locations.each do |loc|
        d = loc.manhattan_dist(pt)
        if d == 0
          min_locs = [loc]
          min_d = d
          break
        elsif min_d == d # tie
          min_locs << loc
        elsif min_d.nil? || d < min_d
          min_d = d 
          min_locs = [loc]
        end

      end
      if( pt.y != last_y )
        puts "" if verbose
        last_y = pt.y
      end
      if min_locs.length == 1
        min_loc = min_locs.first
        min_loc.points << pt
        dot = min_d == 0 ? min_loc.label : min_loc.label.downcase
        print(dot) if verbose
      else
        print "." if verbose
      end
    end

    puts "" if verbose
    puts "" if verbose

    @locations.each do |loc|
      loc.is_finite = !(loc.bb.tl.x <= bb.tl.x || loc.bb.br.x >= bb.br.x || loc.bb.tl.y <= bb.tl.y || loc.bb.br.y >= bb.br.y)
    end

    puts @locations.map(&:to_s) if verbose

    puts @locations.select(&:is_finite).map {|l| l.points.length }.sort.inspect if verbose
    
    loc = @locations.select(&:is_finite).max_by {|l| l.points.length }
    loc.points.length
  end


  def calc2(safe_dist)

    safe_points = []
    @bb.each_point do |a|

      d = @locations.sum do |b|
        a.manhattan_dist(b)
      end
      safe_points << a if d < safe_dist
    end



    safe_points.length

  end



end