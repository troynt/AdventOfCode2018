require_relative "star"

describe 'Star' do

  it 'should be able to parse from string' do

    s = Star.init_from_str("position=< 9,  1> velocity=< 0,  2>")
    expect(s.pos).to eq([9, 1])
    expect(s.vel).to eq([0, 2])
  end


  it 'should be able step with velocity' do

    s = Star.init_from_str("position=< 9,  1> velocity=< 0,  2>")
    expect(s.pos).to eq([9, 1])
    expect(s.vel).to eq([0, 2])
    s.step
    expect(s.pos).to eq([9, 3])
  end
end