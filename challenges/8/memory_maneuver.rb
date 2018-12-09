# frozen_string_literal: true

require_relative "memory_node"

require 'pry'


class MemoryManeuver
  attr_reader :root

  def initialize(memory_arr, verbose = false)
    @root = MemoryNode.init_from_arr(memory_arr, verbose)

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
        puts '--'
        puts "Parent: #{p.describe} Should Grab #{p.should_grab_metadata?}"
      end

      cur_n = MemoryNode.init_from_arr(memory_arr)
      puts "Current: #{cur_n.describe}" if verbose

      if p.missing_children?
        p.add_child(cur_n)
        puts p.describe if verbose
      end

      if cur_n.should_grab_metadata?
        cur_n.grab_metadata memory_arr

        while p&.should_grab_metadata?
          p.grab_metadata memory_arr
          p = parent_stack.shift
        end
      end

      if cur_n.missing_children?
        parent_stack.unshift p # put p on stack
        p = cur_n
      end

    end
  end

  def license
    nodes.map(&:license).inject(:+)
  end

  def nodes
    ret = []
    q = [root]
    while (cur = q.shift)
      q.concat cur.children

      ret << cur
    end

    ret
  end
end
