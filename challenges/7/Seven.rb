

class Seven
  START_NODE = "START"
  LINE_REGEXP = %r[Step (.+) must be finished before step (.+) can begin.]

  attr_reader :graph, :order

  def self.parse_line(line)
    # Step A must be finished before step N can begin.

    _, parent, child = LINE_REGEXP.match(line).to_a

    [parent, child]
  end

  def initialize(file_path, worker_count = 0)
    @graph = {}
    @prereqs = {}
    @order = []
    @total_time = 0
    @visited = Set.new
    @workers = {}
    worker_count.times do |i|
      @workers[i] = true
    end
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

  def calc2
    dfs2(root_node)

    0
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
=begin
  def bfs(node)
    q = [node]
    @visited << node
    @order << node

    while q.any?
      cur_node = q.shift
      (@graph[cur_node] || []).each do |adj|
        next if @visited.include? adj
        q << adj
        @visited << adj
        @order << adj
      end
    end
  end
=end
  def self.time_required(node)
    return 0 if node === START_NODE
    node.ord - 64 + 60
  end

  def available_worker
    workers.find_index(&:itself)
  end

  def begin_work(worker)
    workers[worker] = false
  end

  def end_work(worker)
    workers[worker] = true
  end

  def visit_node(node)
    @visited << node
    @order << node unless node == START_NODE
    @prereqs.each do |n, reqs|
      reqs.delete node
    end

    self.class.time_required(node)
  end

  def dfs(node, can_access = SortedSet.new)
    visit_node(node)

    adjs = (@graph[node] || []).select do |adj|
      @prereqs[adj].length == 0
    end

    can_access += adjs

    can_access.each do |adj|
      can_access.delete adj
      next if @visited.include? adj
      dfs(adj, can_access)
    end

  end

  def dfs2(node, can_access = SortedSet.new, time = 0)
    time_needed = visit_node(node)



    adjs = (@graph[node] || []).select do |adj|
      @prereqs[adj].length == 0
    end

    can_access += adjs

    can_access.each do |adj|
      can_access.delete adj
      next if @visited.include? adj
      time_needed += dfs(adj, can_access, time)
    end

    time_needed
  end
end