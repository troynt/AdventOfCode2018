class MineCartCrashException < StandardError  
  attr_reader(
    :track,
    :cart
  )
  def initialize(track:, cart:)
    @track = track
    @cart = cart
  end
end