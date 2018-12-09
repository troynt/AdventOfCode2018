class MemoryNode
  @@id = 64

  attr_accessor(
    :children_qty,
    :metadata_qty,
    :children
  )

  attr_reader(
    :id,
    :verbose,
    :metadata
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
    children_qty > children.length
  end

  def missing_metadata?
    !metadata?
  end

  def metadata?
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
    if children_qty.zero?
      license
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
