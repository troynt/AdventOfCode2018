require_relative "worker_pool"
require 'pry'

class Seven
  START_NODE = "START"
  LINE_REGEXP = %r[Step (.+) must be finished before step (.+) can begin.]

  attr_reader :graph, :order, :worker_pool

  def self.parse_line(line)
    # Step A must be finished before step N can begin.

    _, parent, child = LINE_REGEXP.match(line).to_a

    [parent, child]
  end

  def initialize(file_path, worker_count = 0, base_time_step = 0)
    @graph = {}
    @prereqs = {}
    @order = []
    @total_time = 0
    @visited = Set.new
    @worker_pool = WorkerPool.new(worker_count)
    @base_time_step = base_time_step

    File.open(file_path).each_line do |line|
      parent, child = self.class.parse_line line
      add_edge parent, child
    end
  end

  def add_edge(parent, child)
    @graph[parent] ||= begin
      SortedSet.new
    end
    @graph[parent] << child

    @prereqs[child] ||= begin
      Set.new
    end
    @prereqs[child] << parent
    self
  end

  def calc
    dfs(root_node)


    @order
  end

  def root_node
    @root_node ||= begin
      nodes = SortedSet.new(Set.new(@graph.keys) - @graph.values.reduce(&:+))
      nodes.each do |n|
        add_edge(START_NODE, n)
      end

      START_NODE
    end

  end

  def self.time_required(node, base_time_step)
    return 0 if node === START_NODE
    node.ord - 64 + base_time_step
  end

  def visit_node(node)
    @visited << node
    @order << node unless node == START_NODE
    @prereqs.each do |n, reqs|
      reqs.delete node
    end
  end

  def dfs(node, can_access = SortedSet.new)
    visit_node(node)

    adjs = adjacencies(node)

    can_access += adjs

    can_access.each do |adj|
      can_access.delete adj
      next if @visited.include? adj
      dfs(adj, can_access)
    end

  end

  def finish_node(node)
    @order << node unless node == START_NODE
    @prereqs.each do |n, reqs|
      reqs.delete node
    end
  end

  def step
    # print_state
    @worker_pool.step
    @total_time += 1
  end

  def workers
    worker_pool.workers
  end

  def calc2

    dfs2(root_node)

    step while !worker_pool.done?

    # print_state

    @total_time
  end

  def adjacencies(node, prereq_check = true)
    adjs = (@graph[node] || [])
    
    if prereq_check
      adjs = adjs.select do |adj|
        @prereqs[adj].length == 0
      end
    end
    adjs
  end

  def wait_for_available_worker
    found_worker = worker_pool.first_available_worker
    while !found_worker
      step
      found_worker = worker_pool.first_available_worker
    end
    found_worker
  end

  def requirements_done?(node)
    (@prereqs[node] || []).length == 0
  end

  def dfs2(node)
    if node.nil? || @visited.include?(node)
      return nil
    end

    nodes_to_visit = [node]

    while true
      cur_node = nodes_to_visit.select {|x| requirements_done?(x) }.first
      unless cur_node
        break if worker_pool.done?
        step
        next
      end

      nodes_to_visit.delete(cur_node)

      w = wait_for_available_worker
      visit_node2(cur_node, w)

      nodes_to_visit += adjacencies(cur_node, false).to_a

      nodes_to_visit.select {|x| !@visited.include?(x) }
      nodes_to_visit.uniq!
      nodes_to_visit.sort!
    end
  end


  def visit_node2(node, worker)
    @visited << node
    if node == START_NODE
      finish_node(node)
      yield(node) if block_given?
      return nil
    end

    worker.work_on(node, self.class.time_required(node, @base_time_step)) do
      finish_node(node)
      yield(node) if block_given?
    end
  end

  def print_state
    puts "\n#{@total_time}\t#{workers.map(&:describe).join("\t")}\t#{@order.join ""}"
  end

end