
require_relative 'chronal_charge'

describe 'ChronalCharge' do
  it "should be able to calculate power levels" do
    a = ChronalChargeCell.new(ChronalCharge.new(8), 3, 5)
    expect(a.value).to eq(4)

    a = ChronalChargeCell.new(ChronalCharge.new(57), 122, 79)
    expect(a.value).to eq(-5)

    a = ChronalChargeCell.new(ChronalCharge.new(39), 217, 196)
    expect(a.value).to eq(0)

    a = ChronalChargeCell.new(ChronalCharge.new(71), 101, 153)
    expect(a.value).to eq(4)

  end

  it "should be able to solve sample" do

    c = ChronalCharge.new(42, verbose: true)
    expect(c.calc).to eq([21, 61, 3])

  end

  it "should be able to solve the puzzle" do
    c = ChronalCharge.new(9221)
    expect(c.calc).to eq([20, 77, 3])
  end

  it "should be able to solve the puzzle" do
    c = ChronalCharge.new(9221)
    expect(c.calc).to eq([20, 77, 3])
  end

  it "should be able to solve part 2" do
    c = ChronalCharge.new(9221)
    expect(c.calc2).to eq([143, 57, 10])
  end

end
