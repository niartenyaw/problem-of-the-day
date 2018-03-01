require_relative 'heap'

def k_largest_elements(array, k)
  heap = BinaryMinHeap.new { |a, b| a <=> b }
  array.each do |el|
    heap.push(el)
    heap.extract if heap.count > k
  end

  results = []
  k.times { results << heap.extract }
  results
end
