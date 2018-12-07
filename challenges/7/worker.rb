class Worker
    attr_reader :time_left, :node, :done_block
  
    def initialize
      @time_left = 0
    end
  
    def work_on(node, time_required, &block)
      @time_left = time_required
      @node = node
      @done_block = block
    end
  
    def step(time_step = 1)
      if @node
        @time_left -= time_step
        finish! if @time_left <= 0
      end
    end
  
    def finish!
      if @node
        @done_block.call(@node)
        @done_block = nil
        @node = nil
        @time_left = 0
      end
    end

    def describe
      @node || "."
    end
  
    def available?
      @time_left <= 0
    end
  
    def unavailable?
      !available?
    end
  
  end
  