class Fringe
  def initialize(store = {})
    @store = store
  end

  # Stores a new entry in the fringe if the new entry is superior to
  # the old entry.
  #
  # Return a hash of { action, fringe }. Fringe should be either self
  # (if prior entry was superior) or a new Fringe with a new store. Do
  # not mutate the original fringe.
  #
  # Action should be one of (a) :old_entry_better, (b) :insert (first
  # entry for this vertex, or (c) :update (replaced worse entry).
  def add_entry(entry)
    dest_vertex = entry.destination_vertex
    if @store[dest_vertex]
      if entry.superior_to?(@store[dest_vertex])
        new_store = @store.dup
        new_store[dest_vertex] = entry
        return { action: :update, fringe: self.class.new(new_store) }
      else
        return { action: :old_entry_better, fringe: self}
      end
    else 
      new_store = @store.dup
      new_store[dest_vertex] = entry
      return { action: :insert, fringe: self.class.new(new_store) }
    end

  end

  # Return the lowest cost, best entry in the fringe. Return a hash of
  # { best_entry, fringe }. Again, create a new store with a new
  # Fringe and don't mutate this one.
  def extract
    min_entry = nil
    @store.each_value do |entry| 
      if min_entry
        min_entry = entry if entry.superior_to?(min_entry)
      else 
        min_entry = entry
      end
    end

    new_store = @store.dup
    new_store.delete(min_entry.destination_vertex)
    return { best_entry: min_entry, fringe: self.class.new(new_store) }
  end

  def empty?
    @store.empty?
  end

  def ==(other_fringe)
    store == other_fringe.store
  end

  def to_hash
    hash = {}
    @store.each do |v, entry|
      hash[v.name] = entry.to_hash
    end

    hash
  end

  protected
  attr_reader :store
end
