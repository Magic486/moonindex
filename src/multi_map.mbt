// MultiMap - A map that can associate multiple values with a single key
// Useful for adjacency lists, HTTP headers, and grouping operations

///|
pub struct MultiMap[K, V] {
  // Uses IndexMap internally with Array[V] as value
  map : IndexMap[K, Array[V]]
}

///|
/// Create a new empty MultiMap
pub fn[K : Hash + Eq, V] MultiMap::new() -> MultiMap[K, V] {
  MultiMap::{ map: IndexMap::new() }
}

///|
/// Insert a key-value pair. If key exists, append to existing values.
pub fn[K : Hash + Eq, V] MultiMap::insert(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  match self.map.get(key) {
    Some(values) => values.push(value)
    None => {
      let arr = [value]
      self.map.insert(key, arr)
    }
  }
}

///|
/// Get all values for a key
pub fn[K : Hash + Eq, V] MultiMap::get(
  self : MultiMap[K, V],
  key : K,
) -> Array[V]? {
  self.map.get(key)
}

///|
/// Get the first value for a key
pub fn[K : Hash + Eq, V] MultiMap::get_first(
  self : MultiMap[K, V],
  key : K,
) -> V? {
  match self.map.get(key) {
    Some(values) => if values.length() > 0 { Some(values[0]) } else { None }
    None => None
  }
}

///|
/// Get the number of values for a key
pub fn[K : Hash + Eq, V] MultiMap::get_count(
  self : MultiMap[K, V],
  key : K,
) -> Int {
  match self.map.get(key) {
    Some(values) => values.length()
    None => 0
  }
}

///|
/// Check if key exists
pub fn[K : Hash + Eq, V] MultiMap::contains(
  self : MultiMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// Check if a specific key-value pair exists
pub fn[K : Hash + Eq, V : Eq] MultiMap::contains_pair(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  match self.map.get(key) {
    Some(values) => values.contains(value)
    None => false
  }
}

///|
/// Remove all values for a key
pub fn[K : Hash + Eq, V] MultiMap::remove_all(
  self : MultiMap[K, V],
  key : K,
) -> Bool {
  self.map.remove(key)
}

///|
/// Remove a specific key-value pair. Returns true if removed.
pub fn[K : Hash + Eq, V : Eq] MultiMap::remove_pair(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  match self.map.get(key) {
    Some(values) => {
      let mut idx = -1
      for i = 0; i < values.length(); i = i + 1 {
        if values[i] == value {
          idx = i
          break
        }
      }
      if idx >= 0 {
        values.remove(idx) |> ignore
        if values.is_empty() {
          self.map.remove(key) |> ignore
        }
        true
      } else {
        false
      }
    }
    None => false
  }
}

///|
/// Get the number of unique keys
pub fn[K, V] MultiMap::key_count(self : MultiMap[K, V]) -> Int {
  self.map.length()
}

///|
/// Get the total number of values across all keys
pub fn[K, V] MultiMap::total_count(self : MultiMap[K, V]) -> Int {
  let mut count = 0
  for entry in self.map.iter() {
    let values = entry.1
    count = count + values.length()
  }
  count
}

///|
/// Check if the map is empty
pub fn[K, V] MultiMap::is_empty(self : MultiMap[K, V]) -> Bool {
  self.map.is_empty()
}

///|
/// Iterate over key-value pairs (each value is an array)
pub fn[K, V] MultiMap::iter(self : MultiMap[K, V]) -> Iter[(K, Array[V])] {
  self.map.iter()
}

///|
/// Iterate over all individual key-value pairs (flattened)
pub fn[K, V] MultiMap::iter_flat(self : MultiMap[K, V]) -> Iter[(K, V)] {
  let result = []
  for entry in self.map.iter() {
    let key = entry.0
    let values = entry.1
    for value in values.iter() {
      result.push((key, value))
    }
  }
  result.iter()
}

///|
/// Get all keys
pub fn[K, V] MultiMap::keys(self : MultiMap[K, V]) -> Array[K] {
  self.map.keys()
}

///|
/// Get all values (flattened)
pub fn[K, V] MultiMap::all_values(self : MultiMap[K, V]) -> Array[V] {
  let result = []
  for entry in self.map.iter() {
    let values = entry.1
    for value in values.iter() {
      result.push(value)
    }
  }
  result
}

///|
/// Clear all entries
pub fn[K, V] MultiMap::clear(self : MultiMap[K, V]) -> Unit {
  self.map.clear()
}
