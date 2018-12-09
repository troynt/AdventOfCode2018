class Marble
  attr_reader(
    :value
  )

  attr_accessor(
    :prev,
    :next
  )
  def initialize(value, prev = nil, next_marble = nil)
    @value = value
    @next = next_marble || self
    @prev = prev || self
  end
end