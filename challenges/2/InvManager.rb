class InvManager

  def initialize(filepath)
    f = File.open(filepath)
    @ids = f.readlines.map(&:strip).map { |id| parse_id(id)}
  end

  def parse_id(id)
    Set.new id.chars.group_by {|i| i}.map { |k,v| v.length }
  end

  def calc
    twos = 0
    threes = 0

    @ids.each do |parsed_id|
      twos += 1 if parsed_id.include?(2)
      threes += 1 if parsed_id.include?(3)
    end

    twos * threes
  end
end