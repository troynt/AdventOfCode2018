# frozen_string_literal: true

require 'shortest/path/general'
require_relative 'beverage_bandits'

describe 'BeverageBandit' do
  def get_data(file_path)
    File.open(File.join(File.dirname(__FILE__), file_path))
  end

  it 'should be able to parse board' do
    b = BeverageBandit.new(get_data('fixtures/sample.txt'))

    expect(b.board.length).to eq(81)

    expect(b.characters.length).to eq(9)

    b.battle
  end

  it 'should be able to handle sample board 2' do
    b = BeverageBandit.new(get_data('fixtures/sample2.txt'))

    expect(b.board.length).to eq(49)

    expect(b.characters.length).to eq(6)

    expect(b.battle).to eq([47, 590])
  end

  it 'should be able to handle sample board 3' do
    b = BeverageBandit.new(get_data('fixtures/sample3.txt'))

    expect(b.battle).to eq([37, 982])
  end

  it 'should be able to handle sample board 4' do
    b = BeverageBandit.new(get_data('fixtures/sample4.txt'))

    expect(b.battle).to eq([46, 859])
  end

  it 'should be able to handle sample board 5' do
    b = BeverageBandit.new(get_data('fixtures/sample5.txt'))

    expect(b.battle).to eq([35, 793])
  end


  it 'should be able to handle sample board 6' do
    b = BeverageBandit.new(get_data('fixtures/sample6.txt'))

    expect(b.battle).to eq([54, 536])
  end

  it 'should be able to solve input' do
    b = BeverageBandit.new(get_data('fixtures/input.txt'))
    rounds, hp = b.battle
    expect(rounds * hp).to eq(237_996)
  end

  it 'should be able to solve part two' do
    team_attack_power = { "G" => 3, "E" => 3}
    found = false
    loop do

      b = BeverageBandit.new(get_data('fixtures/input.txt'), team_attack_power: team_attack_power)
      elf_count = b.characters.select(&:elf?).length
      rounds, hp, alive_chars_by_team = b.battle(return_alive_chars: true, max_elf_deaths: 1)
      if !alive_chars_by_team["E"].nil? && alive_chars_by_team["E"].length == elf_count
        expect(rounds * hp).to eq(69_700)
        found = true
        break
      else
        team_attack_power["E"] += 1
        # puts "Elf died, raising attack power to #{team_attack_power["E"]}"
      end
    end

    expect(found).to eq(true)

  end


end
