class Guard
  attr_reader :id
  attr_accessor :entries
  attr_reader :times_sleeping

  def initialize(id)
    @id = id
    @entries = []
  end

  def to_s
    "##{id}: #{entries.length}"
  end

  def time_sleeping
    (@time_sleeping || 0) / 60
  end

  def sleep_max
    @sleep_max ||= begin
      sleep_mins.max_by do |min, cnt|
        cnt
      end
    end

  end

  def sleep_mins
    counts = {}
    times_sleeping.each do |sleep_range|
      start = sleep_range.begin
      while start <= sleep_range.end
        minute = start.min
        counts[minute] ||= 0
        counts[minute] += 1
        start += 60
      end
    end
    counts
  end

  def calc
    prev_e = nil
    state = "awake"
    @time_sleeping = 0
    @times_sleeping = []
    @entries.each do |e|
      if( prev_e.nil? )
        prev_e = e
        next
      end

      delta = e.time - prev_e.time - 60
      if( state == "sleeping" )
        @time_sleeping += delta + 60
        @times_sleeping << (prev_e.time..prev_e.time+delta)
      end
      old_state = state
      state = e.state || state

      prev_e = e

    end

  end

end

class LogEntry

  attr_reader :entry
  attr_reader :time
  attr_reader :guard_id
  attr_reader :state

  def initialize(str)
    # [1518-11-01 00:00] Guard #10 begins shift

    _, time, entry = str.match(/\[(.*)\] (.*)/).to_a

    @time = Time.parse(time += " UTC")
    @entry = entry


    _, guard_id = entry.match(/#(\d+)/).to_a
    @guard_id = guard_id && guard_id.to_i

    _, state = entry.match(/(asleep|wake|begins)/).to_a

    @state = {
      "begins" => "awake",
      "wake" => "awake",
      "asleep" => "sleeping"
    }[state]
  end
end

class Four
  attr_accessor :entries

  attr_reader :guards

  def initialize(filepath)
    @entries = File.open(filepath).readlines.map {|line| LogEntry.new(line.strip) }.sort_by(&:time)

  end

  def guards
    @guards ||= begin
      ret = {}
      cur_guard = nil
      entries.each do |e|
        if e.guard_id
          cur_guard = ret[e.guard_id] ||= begin
            Guard.new(e.guard_id)
          end
        end

        cur_guard.entries << e
      end

      ret.values.map(&:calc)

      ret
    end
  end

  def calc
    guard_id, g = guards.max_by {|k, guard| guard.time_sleeping }
    minute, count = g.sleep_max

    minute * g.id
  end

  def calc2
    g = guards.values.select {|g| g.sleep_mins.length > 0 }.max_by do |g|
      min, cnt = g.sleep_max

      cnt
    end

    min, cnt = g.sleep_max

    min * g.id
  end


end