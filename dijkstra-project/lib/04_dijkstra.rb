require_relative './01_result_entry'
require_relative './02_result_map'
require_relative './03_fringe'
require_relative './ff_messages'

# This method will have you call Fiber.yield to yield various messages
# (listed in ff_messages) to indicate what your algorithm is doing
# along the way.
def dijkstra(start_vertex)
  # 1. Start empty result map and fringe with just the start
  # vertex. Yield initialization message.
  map = ResultMap.new
  start_entry = ResultEntry.new(start_vertex, nil, 0)
  fringe = Fringe.new.add_entry(start_entry)[:fringe]
  Fiber.yield(InitializationMessage.new(map, fringe))
  # 2. Each time, extract the minimum cost entry from the fringe. Add
  # it to the result. Yield extraction message.
  until fringe.empty?
    extract_result = fringe.extract
    min_cost_entry = extract_result[:best_entry]
    fringe = extract_result[:fringe]
    map = map.add_entry(min_cost_entry)
    Fiber.yield(ExtractionMessage.new(map, fringe, min_cost_entry))
    # 3. Process all outgoing edges from the vertex by using
    # add_vertex_edges.
    fringe = add_vertex_edges(map, fringe, min_cost_entry)
    # 4. When done processing edges for the extracted entry, yield
    # competion message.
    Fiber.yield(UpdateCompletionMessage.new(map, fringe, min_cost_entry))
    # 5. When entirely all done, *return* (not yield) the result map.
  end

  return map
end

def add_vertex_edges(result_map, fringe, best_entry)
  # 1. Iterate through each edge of the extracted vertex (call this
  # vertex_a).
  vertex_a = best_entry.destination_vertex
  vertex_a.edges.each do |edge|
    # 2. For each edge, build a candidate result entry for the vertex on
    # the other side of the edge (call this vertex_b).
    vertex_b = edge.other_vertex(vertex_a)
    candidate_result_entry = ResultEntry.new(vertex_b, edge, best_entry.cost_to_vertex + edge.cost)
    
    # 2a. Skip if we already have vertex_b in the visited set. Yield an
    # EdgeConsiderationMessage of :result_map_has_vertex.
    if result_map.has_vertex?(vertex_b)
      Fiber.yield(EdgeConsiderationMessage.new(result_map, fringe, candidate_result_entry, :result_map_has_vertex))
    else 
      # 2b. Else try to add the edge to the fringe. Yield an edge
      # consideration message with the action set to the outcome of the
      # attempted insertion into the fringe.
      result = fringe.add_entry(candidate_result_entry)
      fringe = result[:fringe]
      Fiber.yield(EdgeConsiderationMessage.new(result_map, fringe, candidate_result_entry, result[:action]))
    end
  end
  


  # 3. When all done with the edges of vertex_a, return the updated
  # fringe.
  fringe
end
