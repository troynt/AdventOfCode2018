require_relative 'mine_track'

describe 'MineTrack' do
  it 'should be able to parse a track' do
    a = MineTrack.new("|", 0, 0)
    expect(a.type).to eq(:vert)
  end
end