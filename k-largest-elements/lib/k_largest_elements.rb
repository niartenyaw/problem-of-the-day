require_relative 'heap'

def k_largest_elements(array, k)
  heap = BinaryMinHeap.new { |a, b| b <=> a }
  array.each { |el| heap.push(el) }

  results = []
  k.times { results << heap.extract }
  results
end
