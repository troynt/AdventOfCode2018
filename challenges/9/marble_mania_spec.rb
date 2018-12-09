
require_relative 'marble_mania'

describe 'MarbleMania' do

  def init(str, opts = {})
    m = MarbleMania.init_from_str(str, opts)
    m.play
    m
  end

  it 'should be able to create game from string' do
    m = MarbleMania.init_from_str("10 players; last marble is worth 1618 points")

    expect(m.players.length).to eq(10)
    expect(m.final_marble_value).to eq(1618)
  end

  it 'should be able to calculate high score for sample inputs' do
    m = init("9 players; last marble is worth 1618 points", max_rounds: 25)
    expect(m.highscore).to eq(32)
    expect(m.players[4].score).to eq(32)
    expect(m.marbles).to eq("0 16 8 17 4 18 19 2 24 20 25 10 21 5 22 11 1 12 6 13 3 14 7 15".split(" ").map(&:to_i))

    m = init("10 players; last marble is worth 1618 points")
    expect(m.highscore).to eq(8317)
    expect(m.players.length).to eq(10)


    m = init("13 players; last marble is worth 7999 points")
    expect(m.highscore).to eq(146373)
  end

  it 'should be able to solve part 1' do
    m = init("419 players; last marble is worth 71052 points")

    expect(m.highscore).to eq(412117)
  end


  it 'should be able to solve part 2' do
    m = init("419 players; last marble is worth 7105200 points")

    expect(m.highscore).to eq(3444129546)
  end
end
