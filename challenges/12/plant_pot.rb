class PlantPot
  attr_accessor(
    :state,
    :next,
    :prev,
    :next_state,
    :location
  )

  def initialize(state, location: nil)
    @state = state
    @location = location
  end

  def state_with_neighbors
    self_with_neighbors.map(&:state).map {|x| !x.nil? && x == true ? '#' : '.'}.join ''
  end

  def self_with_neighbors
    ret = []
    5.times {ret << PlantPot.new(false)}

    if prev
      ret[1] = prev
      ret[0] = prev.prev unless prev.prev.nil?
    end

    ret[2] = self

    if self.next
      ret[3] = self.next
      ret[4] = self.next.next unless self.next.next.nil?
    end

    ret

  end

  def has_plant?
    state
  end

  def to_i
    has_plant? ? location : 0
  end

  def to_s
    has_plant? ? '#' : '.'
  end
end