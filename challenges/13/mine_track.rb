class MineTrack
  attr_accessor(
    :type,
    :contains,
    :up,
    :left,
    :down,
    :right,
    :x,
    :y
  )

  def initialize(char, x, y)
    @type = self.class.type_from_char(char)
    @x = x
    @y = y
  end

=begin
/---\
|   |
|   |
\---/

=end
  def self.type_from_char(char)
    case char
    when "-", "<", ">"
      return :hor
    when "|", "^", "v"
      return :vert
    when  "\\"
      return :ldiag
    when "/"
      return :rdiag
    when "+"
      return :inter
    end

    raise "Unable to determine type for #{char}"
  end

  def neighbors
    ret = {}
    [:up, :right, :down, :left].each do |s|
      ret[s] = self.send(s)
    end

    ret
  end

  def up=(track)
    @up = track
    track.down = self unless track.nil?
  end

  def left=(track)
    @left = track
    track.right = self unless track.nil?
  end

  def to_s
    if occupied?
      contains.to_s
    else
      { hor: "-", vert: "|", ldiag: "\\", rdiag: "/", inter: "+"  }[type]
    end
  end

  def tick
    contains.tick(self) if occupied?
  end

  def diag?
    [:ldiag, :rdiag].include?(type)
  end

  def occupied?
    !self.contains.nil?
  end
end
