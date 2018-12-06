Claim = Struct.new(:id, :x, :y, :w, :h) do

  def to_squares
    @to_squares ||= begin
      ret = Set.new
      w.times do |i|
        h.times do |j|
          ret.add "#{i+x}_#{j+y}"
        end
      end
      
      ret
    end
  end

  def overlaps?(claim)
    a = claim.to_squares
    b = to_squares
    a.intersect? b
  end

  def self.init_from_str(str)
    match = str.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)

    _, id, x, y, w, h = match.to_a

    new(id, x.to_i, y.to_i, w.to_i, h.to_i)
  end
end

class Three
  attr_accessor :claims

  def initialize(filepath)
    @claims = File.open(filepath).readlines.map {|line| Claim.init_from_str(line.strip) }

  end

  def calc
    @claims.map(&:to_squares).map(&:to_a).flatten.group_by(&:itself).map { |k,v| [k, v.length] }.select { |sq| sq[1] > 1 }.length
  end

  def calc2
    has_overlaps = Set.new

    found_claim = @claims.find do |claim|
      next if has_overlaps.include?(claim)

      !@claims.any? do |c|
        next if c == claim

        if claim.overlaps?(c)
          has_overlaps.add(c)
          true
        else
          false
        end
      end
    end
    found_claim && found_claim.id
  end

end