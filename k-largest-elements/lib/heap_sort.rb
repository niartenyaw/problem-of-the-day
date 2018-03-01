require_relative "heap"
require "byebug"
class Array
  def heap_sort!(&prc)
    prc ||= Proc.new { |a, b| a <=> b }
    new_prc = Proc.new { |a, b| -1 * prc.call(a, b) }

    length.times do |i|
      BinaryMinHeap.heapify_up(self, i, i + 1, &new_prc)
    end

    last_heap_index = length - 1
    length.times do
      self[0], self[last_heap_index] = self[last_heap_index], self[0]
      BinaryMinHeap.heapify_down(self, 0, last_heap_index, &new_prc)
      last_heap_index -= 1
    end
  end
end
