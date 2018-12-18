# frozen_string_literal: true

require_relative 'settlers_of_the_north_pole'
require 'pry'

describe 'SettlersofTheNorthPole' do
  def get_data(file_path)
    File.open(File.join(File.dirname(__FILE__), file_path))
  end

  it 'should be able handle sample data' do
    a = SettlersofTheNorthPole.new(get_data("fixtures/sample.txt"))

    a.simulate(count: 10)

    expect([a.tree_count, a.lumberyard_count]).to eq([37, 31])
  end

  it 'should be able handle 1000 minutes for part two' do
    a = SettlersofTheNorthPole.new(get_data("fixtures/input.txt"))

    a.simulate(count: 1000, allow_shortcut: true)
    expect(a.tree_count * a.lumberyard_count).to eq(203138)
  end

  it 'should be able handle input data for part two' do
    a = SettlersofTheNorthPole.new(get_data("fixtures/input.txt"))

    a.simulate(count: 1000000000, allow_shortcut: true)

    expect(a.tree_count * a.lumberyard_count).to eq(203138)
  end
end
