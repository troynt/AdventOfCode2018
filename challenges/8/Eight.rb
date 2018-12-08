require 'pry'

class Node
  @@id = 64

  attr_accessor(
    :children_qty,
    :metadata_qty,
    :children,
    :metadata
  )

  attr_reader(
    :id,
    :verbose,
  )

  def self.init_from_arr(data, verbose = false)

    return if data.empty?
    
    n = new(verbose)
    n.children_qty, n.metadata_qty = data.shift(2).map(&:to_i)
    n.children = []

    n
  end

  def add_child(node)
    puts "Adding #{node.id} to #{id}" if verbose
    children << node
  end


  def grab_metadata(data)
    @metadata = data.shift(metadata_qty)
    puts "#{id} grabbed meta #{@metadata}" if verbose
  end

  def missing_children?
    @children_qty > @children.length
  end

  def missing_metadata?
    !has_metadata?
  end

  def has_metadata?
    metadata.length == metadata_qty
  end

  def should_grab_metadata?
    !missing_children? && missing_metadata? && children.none?(&:missing_metadata?)
  end

  def initialize(verbose = false)
    @id = (@@id += 1)
    @metadata = []
    @children = []
    @verbose = verbose
  end

  def license
    metadata.inject(:+) || 0
  end

  def values
    @values ||= children.map(&:value)
  end

  def value
    if children_qty == 0
      return license
    else
      metadata.reduce(0) do |acc, idx|
        acc + (values[idx - 1] || 0)
      end
    end
  end

  def describe
    "#{id} Children: #{children.length}/#{children_qty}. Meta #{metadata.length}/#{metadata_qty}"
  end

end


class Eight
  attr_reader :root


  def initialize(memory_arr, verbose = false)
    @root = Node.init_from_arr(memory_arr, verbose)

    parent_stack = []
    p = root # current parent

    puts root.describe if verbose
    while p
      break if memory_arr.empty?

      if p.should_grab_metadata?
        p.grab_metadata memory_arr
        p = parent_stack.shift
      end

      break if p.nil?

      if verbose
        puts "--"
        puts "Parent: #{p.describe} Should Grab #{p.should_grab_metadata?}"
      end
      
      cur_n = Node.init_from_arr(memory_arr)
      puts "Current: #{cur_n.describe}" if verbose


      if p.missing_children?
        p.add_child(cur_n)
        puts p.describe if verbose
      end

      if cur_n.should_grab_metadata?
        cur_n.grab_metadata memory_arr

        while p && p.should_grab_metadata?
          p.grab_metadata memory_arr
          p = parent_stack.shift
        end
      end

      if cur_n.missing_children?
        parent_stack.unshift p # put p on stack
        p = cur_n
      end

    end

    #binding.pry

  end

  def license
    nodes.map(&:license).inject(:+)
  end

  def nodes
    ret = []
    q = [root]
    while cur = q.shift
      q.concat cur.children

      ret << cur
    end

    ret
  end

end