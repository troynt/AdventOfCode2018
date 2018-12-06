require 'time'
require_relative "./Six"

describe 'Six' do
  def init_with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    Six.new File.join(cur_dir,file_path)
  end

  it 'should be able to initialize with locations and bounding box' do
    a = init_with_data("fixtures/sample.txt")
    expect(a.locations.length).to be > 0
    expect(a.bb.tl.x).to eq(1)
    expect(a.bb.tl.y).to eq(1)
    expect(a.bb.br.x).to eq(8)
    expect(a.bb.br.y).to eq(9)
  end

  it 'should be able to calculate manhatten distance' do
    expect(Point.new(0, 0).manhattan_dist(Point.new(1, 1))).to eq(2)
    expect(Point.new(0, 0).manhattan_dist(Point.new(0, 0))).to eq(0)
  end

  it 'should be able to check equality on points' do
    expect(Point.new(1,2)).to eq(Point.new(1,2))
  end

  it 'should be able to find max area for sample' do
    a = init_with_data("fixtures/sample.txt")
    expect(a.calc(false)).to eq(17)
  end

  it 'should be able to find max area', tag: :slow do
    a = init_with_data("fixtures/input.txt")
    expect(a.calc(false)).to eq(4060)
  end

  it 'should be able to find safe region area on sample' do
    a = init_with_data("fixtures/sample.txt")
    expect(a.calc2(32)).to eq(16)
  end

  it 'should be able to find safe center' do
    a = init_with_data("fixtures/input.txt")
    expect(a.calc2(10000)).to eq(36136)
  end
end