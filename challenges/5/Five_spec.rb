require 'time'
require_relative "./Five"

describe 'Five' do
  cur_dir = File.dirname(__FILE__)
  INPUT = File.open(File.join(cur_dir, "fixtures/input.txt")).readlines.first

  it 'should be able to calculate reactions' do

    expect(Five.calc("dabAcCaCBAcCcaDA")).to eq("dabCBAcaDA")
  end

  it 'should be able to calculate solution' do
    expect(Five.calc(INPUT).length).to eq(9900)
  end

  it 'should be able to calculate solution 2' do
    expect(Five.calc2(INPUT)).to eq(4992)
  end
end