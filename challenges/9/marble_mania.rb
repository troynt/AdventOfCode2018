require 'pry'

class Marble
  attr_reader(
    :value
  )

  attr_accessor(
    :prev,
    :next
  )
  def initialize(value, prev = nil, next_marble = nil)
    @value = value
    @next = next_marble || self
    @prev = prev || self
  end
end

class MarblePlayer
  attr_reader(
    :name
  )

  attr_accessor(
    :score
  )

  def initialize(name)
    @score = 0
    @name = name
  end

  def to_s
    "P#{name} (#{score})"
  end
end

class MarbleMania
  attr_reader(
    :players,
    :last_marble,
    :cur_marble_idx,
    :marbles,
    :final_marble_value,
    :verbose,
    :max_rounds,
    :use_linked_list
  )


  def initialize(num_players:, final_marble_value:, verbose: false, max_rounds: nil, use_linked_list: true)
    @players = (1..num_players).map { |x| MarblePlayer.new(x) }
    @marbles = []
    @final_marble_value = final_marble_value
    @verbose = verbose
    @max_rounds = max_rounds
    @use_linked_list = use_linked_list
  end

  def cur_marble
    @marbles[cur_marble_idx]
  end


  def self.init_from_str(str, opts = {})
    # 419 players; last marble is worth 71052 points
    _, num_players, final_marble_value = %r[^(\d+) players; last marble is worth (\d+) points].match(str).to_a

    opts[:num_players] = num_players.to_i
    opts[:final_marble_value] = final_marble_value.to_i

    new(opts)
  end

  def self.pick_idx(cur_idx, distance, length)
    return 0 if cur_idx.nil? || length == 0
    return cur_idx if distance == 0

    ret = (cur_idx + distance) % length
    if ret == 0
      length
    else
      ret
    end
  end

  def highscore
    players.max_by(&:score).score
  end

  def pick_idx(cur_idx, distance)
    length = @marbles.length
    self.class.pick_idx(cur_idx, distance, length)
  end

  def marbles
    if use_linked_list
      x = @marble_circle_start
      ret = []
      loop do
        ret << x.value
        x = x.next
        break if x == @marble_circle_start
      end

      ret
    else
      @marbles
    end
  end


  def play
    marble_id = 1
    @marbles = [0]
    @marble_circle_start = Marble.new(0)

    cur_marble = @marble_circle_start

    cur_marble_idx = 0
    cur_round = 0
    skip_player = false

    players.cycle do |cur_player|
      cur_round += 1
      break if max_rounds && cur_round > max_rounds

      if marble_id != 0 && marble_id % 23 == 0
        orig_marble_id = marble_id
        points_to_award = marble_id

        if use_linked_list
          7.times { cur_marble = cur_marble.prev }
          marble_to_remove = cur_marble.value

          cur_marble.prev.next = cur_marble.next
          cur_marble.next.prev = cur_marble.prev

          cur_marble = cur_marble.next
          points_to_award += marble_to_remove
        else
          marble_to_remove_idx = (cur_marble_idx - 7) % @marbles.length
          marble_to_remove = @marbles[marble_to_remove_idx]
          points_to_award += marble_to_remove
          marbles.delete_at marble_to_remove_idx
          cur_marble_idx = marble_to_remove_idx
        end
        marble_id += 1

        puts "R#{cur_round} #{cur_player} scores #{orig_marble_id}+#{marble_to_remove}=#{points_to_award}" if verbose

        cur_player.score += points_to_award
        next
      end

      if use_linked_list
        m = Marble.new(marble_id, cur_marble.next, cur_marble.next.next)
        cur_marble.next.next.prev = m
        cur_marble.next.next = m
        cur_marble = m
        puts "R#{cur_round} #{cur_player}\t#{marbles.map {|x| x == marble_id ? "(#{x})" : x }.join(" ")}" if verbose
      else
        cur_marble_idx = pick_idx(cur_marble_idx, 2)
        @marbles.insert(cur_marble_idx, marble_id)
        puts "R#{cur_round} #{cur_player}\t#{marbles.map.with_index {|x,i| i == cur_marble_idx ? "(#{x})" : x }.join(" ")}" if verbose
      end
    
      marble_id += 1


      # puts "#{marble_id * 100.0 / final_marble_value}"
      if marble_id > final_marble_value
        if verbose
          puts "#{marble_id}"
          puts "--", "Scores:", players.map(&:to_s)
        end
        return players.max_by(&:score).score
      end

      
    end
  end
end
