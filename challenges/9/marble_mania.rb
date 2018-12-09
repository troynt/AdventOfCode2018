# frozen_string_literal: true

require 'pry'
require_relative 'marble'
require_relative 'marble_player'

class MarbleMania
  attr_reader(
    :players,
    :final_marble_value,
    :verbose,
    :max_rounds,
    :use_linked_list
  )

  def initialize(num_players:, final_marble_value:, verbose: false, max_rounds: nil, use_linked_list: true)
    @players = (1..num_players).map { |x| MarblePlayer.new(x) }
    @final_marble_value = final_marble_value
    @verbose = verbose
    @max_rounds = max_rounds
    @use_linked_list = use_linked_list
  end

  def self.init_from_str(str, opts = {})
    # 419 players; last marble is worth 71052 points
    _, num_players, final_marble_value = /^(\d+) players; last marble is worth (\d+) points/.match(str).to_a

    opts[:num_players] = num_players.to_i
    opts[:final_marble_value] = final_marble_value.to_i

    new(opts)
  end

  def highscore
    players.max_by(&:score).score
  end

  def marbles
    x = @marble_circle_start
    ret = []
    loop do
      ret << x.value
      x = x.next
      break if x == @marble_circle_start
    end

    ret
  end

  def play
    marble_id = 1
    @marble_circle_start = Marble.new(0)

    cur_marble = @marble_circle_start
    cur_round = 0

    players.cycle do |cur_player|
      cur_round += 1
      break if max_rounds && cur_round > max_rounds

      if marble_id != 0 && (marble_id % 23).zero?
        orig_marble_id = marble_id
        points_to_award = marble_id

        7.times { cur_marble = cur_marble.prev }
        marble_to_remove = cur_marble.value

        cur_marble.prev.next = cur_marble.next
        cur_marble.next.prev = cur_marble.prev

        cur_marble = cur_marble.next
        points_to_award += marble_to_remove

        marble_id += 1

        puts "R#{cur_round} #{cur_player} scores #{orig_marble_id}+#{marble_to_remove}=#{points_to_award}" if verbose

        cur_player.score += points_to_award
        next
      end

      m = Marble.new(marble_id, cur_marble.next, cur_marble.next.next)
      cur_marble.next.next.prev = m
      cur_marble.next.next = m
      cur_marble = m
      puts "R#{cur_round} #{cur_player}\t#{marbles.map { |x| x == marble_id ? "(#{x})" : x }.join(' ')}" if verbose

      marble_id += 1

      if marble_id > final_marble_value
        if verbose
          puts marble_id.to_s
          puts '--', 'Scores:', players.map(&:to_s)
        end
        return players.max_by(&:score).score
      end
    end
  end
end
