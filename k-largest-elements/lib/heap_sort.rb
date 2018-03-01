require_relative "heap"

class Array
  def heap_sort!(&prc)
    heap = BinaryMinHeap.new(&prc)
    each { |el| heap.push(el) }
    length.times { |i| self[i] = heap.extract }
  end
end
