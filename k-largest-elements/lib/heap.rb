require "byebug"

class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []
    @prc = prc
  end

  def count
    @store.length
  end

  def extract
    min = store.first
    store[0] = store.pop
    self.class.heapify_down(store, 0, &prc)
    min
  end

  def peek
    @store.last
  end

  def push(val)
    store.push(val)
    self.class.heapify_up(store, count - 1, &prc)
  end

  def self.child_indices(len, parent_index)
    left = parent_index * 2 + 1
    right = parent_index * 2 + 2

    return [] if left >= len
    return [left] if right >= len
    
    [left, right]
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0

    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_index, len = array.length, &prc)

    prc ||= Proc.new { |a, b| a <=> b }

    child_indices = self.child_indices(len, parent_index)

    return array if child_indices.empty?

    switch_index = child_indices.first
    if child_indices.length > 1 
      if prc.call(array[child_indices.first], array[child_indices.last]) == 1
        switch_index = child_indices.last
      end
    end

    if prc.call(array[switch_index], array[parent_index]) == -1
      array[switch_index],
        array[parent_index] =
        array[parent_index],
        array[switch_index]
      self.heapify_down(array, switch_index, len, &prc)
    end

    array
  end

  def self.heapify_up(array, child_index, len = array.length, &prc)
    return array if child_index == 0

    prc ||= Proc.new { |a, b| a <=> b }
    parent_index = self.parent_index(child_index)
    case prc.call(array[child_index], array[parent_index])
    when -1
      array[child_index],
        array[parent_index] =
        array[parent_index],
        array[child_index]
      self.heapify_up(array, parent_index, &prc)
    end
    array
  end
end
