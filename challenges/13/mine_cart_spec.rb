# frozen_string_literal: true

require_relative './mine_cart'

describe 'MineCart' do
  it 'should be able to convert to string' do
    a = MineCart.new(:down)
    expect(a.to_s).to eq('v'.green.bold)
  end

  it 'should be able to set crashed state' do
    a = MineCart.new(:down)
    expect(a.crashed?).to eq(false)
    a.crashed = true
    expect(a.crashed?).to eq(true)
  end
end
