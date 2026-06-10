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

///|
/// Filter entries by a predicate. Preserves order of retained entries.
pub fn[K : Hash + Eq, V] IndexMap::filter(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> IndexMap[K, V] {
  let result = IndexMap::new()
  for entry in self.entries.iter() {
    let (k, v) = entry
    if f(k, v) {
      result.insert(k, v)
    }
  }
  result
}

///|
/// Map values while preserving keys and order.
pub fn[K : Hash + Eq, V, W] IndexMap::map(
  self : IndexMap[K, V],
  f : (V) -> W,
) -> IndexMap[K, W] {
  let result = IndexMap::new()
  for entry in self.entries.iter() {
    let (k, v) = entry
    result.insert(k, f(v))
  }
  result
}

///|
/// Fold over entries in insertion order.
pub fn[K, V, A] IndexMap::fold(
  self : IndexMap[K, V],
  init : A,
  f : (A, K, V) -> A,
) -> A {
  let mut acc = init
  for entry in self.entries.iter() {
    let (k, v) = entry
    acc = f(acc, k, v)
  }
  acc
}

///|
/// Retain only entries that satisfy the predicate. Modifies in place.
pub fn[K : Hash + Eq, V] IndexMap::retain(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> Unit {
  let mut write_pos = 0
  for read_pos = 0; read_pos < self.entries.length(); read_pos = read_pos + 1 {
    let (k, v) = self.entries[read_pos]
    if f(k, v) {
      self.entries[write_pos] = (k, v)
      self.index.set(k, write_pos)
      write_pos = write_pos + 1
    } else {
      self.index.remove(k) |> ignore
    }
  }
  // Truncate entries array to new size
  let new_len = write_pos
  let old_len = self.entries.length()
  for i = new_len; i < old_len; i = i + 1 {
    self.entries.pop() |> ignore
  }
}

///|
/// Swap values of two keys. Returns true if both keys exist.
pub fn[K : Hash + Eq, V] IndexMap::swap(
  self : IndexMap[K, V],
  key1 : K,
  key2 : K,
) -> Bool {
  match (self.index.get(key1), self.index.get(key2)) {
    (Some(pos1), Some(pos2)) => {
      let v1 = self.entries[pos1].1
      let v2 = self.entries[pos2].1
      self.entries[pos1] = (key1, v2)
      self.entries[pos2] = (key2, v1)
      true
    }
    _ => false
  }
}

///|
/// Get entry at specific position or return default.
pub fn[K, V] IndexMap::get_at_or_default(
  self : IndexMap[K, V],
  pos : Int,
  default : (K, V),
) -> (K, V) {
  match self.get_at(pos) {
    Some(entry) => entry
    None => default
  }
}

///|
/// Get value by key or return default.
pub fn[K : Hash + Eq, V] IndexMap::get_or_default(
  self : IndexMap[K, V],
  key : K,
  default : V,
) -> V {
  match self.get(key) {
    Some(v) => v
    None => default
  }
}

///|
/// Check if all entries satisfy the predicate.
pub fn[K, V] IndexMap::all(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> Bool {
  for entry in self.entries.iter() {
    let (k, v) = entry
    if !f(k, v) {
      return false
    }
  }
  true
}

///|
/// Check if any entry satisfies the predicate.
pub fn[K, V] IndexMap::any(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> Bool {
  for entry in self.entries.iter() {
    let (k, v) = entry
    if f(k, v) {
      return true
    }
  }
  false
}

///|
/// Find first entry that satisfies the predicate.
pub fn[K, V] IndexMap::find(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> (K, V)? {
  for entry in self.entries.iter() {
    let (k, v) = entry
    if f(k, v) {
      return Some((k, v))
    }
  }
  None
}

///|
/// Count entries that satisfy the predicate.
pub fn[K, V] IndexMap::count(
  self : IndexMap[K, V],
  f : (K, V) -> Bool,
) -> Int {
  let mut count = 0
  for entry in self.entries.iter() {
    let (k, v) = entry
    if f(k, v) {
      count = count + 1
    }
  }
  count
}

///|
/// Get all entries as array of tuples.
pub fn[K, V] IndexMap::to_array(self : IndexMap[K, V]) -> Array[(K, V)] {
  self.entries.copy()
}

///|
/// Clone the IndexMap.
pub fn[K : Hash + Eq, V] IndexMap::clone(self : IndexMap[K, V]) -> IndexMap[K, V] {
  let result = IndexMap::new()
  for entry in self.entries.iter() {
    let (k, v) = entry
    result.insert(k, v)
  }
  result
}

///|
/// Reverse the order of entries.
pub fn[K : Hash + Eq, V] IndexMap::reverse(self : IndexMap[K, V]) -> Unit {
  let len = self.entries.length()
  for i = 0; i < len / 2; i = i + 1 {
    let j = len - 1 - i
    let temp = self.entries[i]
    self.entries[i] = self.entries[j]
    self.entries[j] = temp
    self.index.set(self.entries[i].0, i)
    self.index.set(self.entries[j].0, j)
  }
}

///|
/// Shift entry to new position. Returns true if successful.
pub fn[K : Hash + Eq, V] IndexMap::shift(
  self : IndexMap[K, V],
  key : K,
  new_pos : Int,
) -> Bool {
  match self.index.get(key) {
    Some(old_pos) => {
      if new_pos < 0 || new_pos >= self.entries.length() {
        return false
      }
      let entry = self.entries[old_pos]
      // Remove from old position
      self.entries.remove(old_pos) |> ignore
      // Insert at new position
      self.entries.insert(new_pos, entry)
      // Update all indices
      for i = 0; i < self.entries.length(); i = i + 1 {
        let (k, _) = self.entries[i]
        self.index.set(k, i)
      }
      true
    }
    None => false
  }
}

///|
/// Get the nth key.
pub fn[K, V] IndexMap::nth_key(self : IndexMap[K, V], n : Int) -> K? {
  match self.get_at(n) {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get the nth value.
pub fn[K, V] IndexMap::nth_value(self : IndexMap[K, V], n : Int) -> V? {
  match self.get_at(n) {
    Some((_, v)) => Some(v)
    None => None
  }
}

///|
/// Check if map contains all given keys.
pub fn[K : Hash + Eq, V] IndexMap::contains_all(
  self : IndexMap[K, V],
  keys : Array[K],
) -> Bool {
  for key in keys.iter() {
    if !self.contains(key) {
      return false
    }
  }
  true
}

///|
/// Check if map contains any of the given keys.
pub fn[K : Hash + Eq, V] IndexMap::contains_any(
  self : IndexMap[K, V],
  keys : Array[K],
) -> Bool {
  for key in keys.iter() {
    if self.contains(key) {
      return true
    }
  }
  false
}

///|
/// Merge another map into this one. Existing keys are updated.
pub fn[K : Hash + Eq, V] IndexMap::merge(
  self : IndexMap[K, V],
  other : IndexMap[K, V],
) -> Unit {
  for entry in other.entries.iter() {
    let (k, v) = entry
    self.insert(k, v)
  }
}

///|
/// Create from array of key-value pairs.
pub fn[K : Hash + Eq, V] IndexMap::from_array(
  arr : Array[(K, V)],
) -> IndexMap[K, V] {
  let result = IndexMap::new()
  for entry in arr.iter() {
    let (k, v) = entry
    result.insert(k, v)
  }
  result
}

///|
/// Pop the last entry. Returns the entry if exists.
pub fn[K : Hash + Eq, V] IndexMap::pop(self : IndexMap[K, V]) -> (K, V)? {
  match self.last() {
    Some((k, v)) => {
      self.remove(k) |> ignore
      Some((k, v))
    }
    None => None
  }
}

///|
/// Pop the first entry. Returns the entry if exists.
pub fn[K : Hash + Eq, V] IndexMap::pop_first(self : IndexMap[K, V]) -> (K, V)? {
  match self.first() {
    Some((k, v)) => {
      self.remove(k) |> ignore
      Some((k, v))
    }
    None => None
  }
}
