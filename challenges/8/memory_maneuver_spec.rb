require_relative 'memory_maneuver'

describe 'MemoryManeuver' do

  def get_data(file_path)
    File.open(File.join(File.dirname(__FILE__),file_path)).readlines.first.split(' ').map(&:to_i)
  end

  it 'should be able to grab meta from data arr' do
    data = [0, 2, 3, 4]
    n = MemoryNode.init_from_arr(data)
    expect(data).to eq([3, 4])
    n.grab_metadata(data)
    expect(data).to eq([])
  end

  it 'should be able to calculate the sample' do
    e = MemoryManeuver.new get_data('fixtures/sample.txt')
    expect(e.root.children.length).to eq(2)
    expect(e.root.children[1].children.length).to eq(1)

    a = e.root
    b = a.children[0]
    c = a.children[1]
    d = c.children[0]

    expect(a.metadata).to eq([1, 1, 2])
    expect(d.metadata).to eq([99])

    expect(e.license).to eq(138)

    expect(a.values).to eq([33, 0])
    expect(a.metadata).to eq([1, 1, 2])

    expect(a.value).to eq(66)
    expect(b.value).to eq(33)
    expect(c.value).to eq(0)
  end

  it 'should be able to calculate the input' do
    e = MemoryManeuver.new get_data('fixtures/input.txt')

    expect(e.license).to eq(47464)
  end

  it 'should be able to calculate the input for part two' do
    e = MemoryManeuver.new get_data('fixtures/input.txt')

    expect(e.root.value).to eq(23054)
  end
end