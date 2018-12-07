require_relative "worker"

class WorkerPool

  attr_reader :workers

  def initialize(worker_count)
    @workers = (0..(worker_count-1)).map { Worker.new }
  end

  def done?
    work_q.empty?
  end

  def work_q
    @workers.map(&:node).compact
  end

  def first_available_worker
    @workers.find(&:available?)
  end

  def step
    @workers.map(&:step)
  end

end