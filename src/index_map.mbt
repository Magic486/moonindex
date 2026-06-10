// IndexMap - Ordered HashMap
// Maintains insertion order while providing O(1) lookup

///|
pub struct IndexMap[K, V] {
  // Stores entries in insertion order
  entries : Array[(K, V)]
  // Maps key to its position in entries array
  index : @hashmap.HashMap[K, Int]
}

///|
/// Create a new empty IndexMap
pub fn[K : Hash + Eq, V] IndexMap::new() -> IndexMap[K, V] {
  IndexMap::{ entries: [], index: @hashmap.HashMap([]) }
}

///|
/// Insert a key-value pair. If key exists, update value while preserving order.
pub fn[K : Hash + Eq, V] IndexMap::insert(
  self : IndexMap[K, V],
  key : K,
  value : V,
) -> Unit {
  match self.index.get(key) {
    Some(pos) =>
      // Key exists, update value
      self.entries[pos] = (key, value)
    None => {
      // New key, append to end
      let pos = self.entries.length()
      self.entries.push((key, value))
      self.index.set(key, pos)
    }
  }
}

///|
/// Get value by key. Returns None if key doesn't exist.
pub fn[K : Hash + Eq, V] IndexMap::get(self : IndexMap[K, V], key : K) -> V? {
  match self.index.get(key) {
    Some(pos) => Some(self.entries[pos].1)
    None => None
  }
}

///|
/// Check if key exists
pub fn[K : Hash + Eq, V] IndexMap::contains(
  self : IndexMap[K, V],
  key : K,
) -> Bool {
  self.index.contains(key)
}

///|
/// Remove a key. Returns true if key was removed, false if not found.
pub fn[K : Hash + Eq, V] IndexMap::remove(
  self : IndexMap[K, V],
  key : K,
) -> Bool {
  match self.index.get(key) {
    Some(pos) => {
      // Remove from entries
      self.entries.remove(pos) |> ignore
      // Remove from index
      self.index.remove(key) |> ignore
      // Update indices for all entries after removed position
      for i = pos; i < self.entries.length(); i = i + 1 {
        let (k, _) = self.entries[i]
        self.index.set(k, i)
      }
      true
    }
    None => false
  }
}

///|
/// Get the number of entries
pub fn[K, V] IndexMap::length(self : IndexMap[K, V]) -> Int {
  self.entries.length()
}

///|
/// Check if the map is empty
pub fn[K, V] IndexMap::is_empty(self : IndexMap[K, V]) -> Bool {
  self.entries.is_empty()
}

///|
/// Iterate over entries in insertion order
pub fn[K, V] IndexMap::iter(self : IndexMap[K, V]) -> Iter[(K, V)] {
  self.entries.iter()
}

///|
/// Get all keys in insertion order
pub fn[K, V] IndexMap::keys(self : IndexMap[K, V]) -> Array[K] {
  self.entries.map(fn(x) { x.0 })
}

///|
/// Get all values in insertion order
pub fn[K, V] IndexMap::values(self : IndexMap[K, V]) -> Array[V] {
  self.entries.map(fn(x) { x.1 })
}

///|
/// Get the first entry (earliest inserted)
pub fn[K, V] IndexMap::first(self : IndexMap[K, V]) -> (K, V)? {
  if self.entries.length() > 0 {
    Some(self.entries[0])
  } else {
    None
  }
}

///|
/// Get the last entry (most recently inserted)
pub fn[K, V] IndexMap::last(self : IndexMap[K, V]) -> (K, V)? {
  let len = self.entries.length()
  if len > 0 {
    Some(self.entries[len - 1])
  } else {
    None
  }
}

///|
/// Get entry at specific position
pub fn[K, V] IndexMap::get_at(self : IndexMap[K, V], pos : Int) -> (K, V)? {
  if pos >= 0 && pos < self.entries.length() {
    Some(self.entries[pos])
  } else {
    None
  }
}

///|
/// Get position of a key in insertion order
pub fn[K : Hash + Eq, V] IndexMap::get_position(
  self : IndexMap[K, V],
  key : K,
) -> Int? {
  self.index.get(key)
}

///|
/// Clear all entries
pub fn[K, V] IndexMap::clear(self : IndexMap[K, V]) -> Unit {
  self.entries.clear()
  self.index.clear()
}

///|
/// Update value using a function. If key doesn't exist, do nothing.
pub fn[K : Hash + Eq, V] IndexMap::update(
  self : IndexMap[K, V],
  key : K,
  f : (V) -> V,
) -> Unit {
  match self.index.get(key) {
    Some(pos) => {
      let (k, v) = self.entries[pos]
      self.entries[pos] = (k, f(v))
    }
    None => ()
  }
}
