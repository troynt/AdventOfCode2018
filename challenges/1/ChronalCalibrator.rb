class ChronalCalibrator

  def initialize(filepath)
    f = File.open(filepath)
    @nums = f.readlines.map(&:to_i)

  end

  def calc(max_runs = 1)
    acc = 0
    seen = {}

    max_runs.times do
      @nums.each do |n|
        acc += n
        if seen[acc] 
          return acc
        else
          seen[acc] = true
        end
      end
    end

    acc
  end
end