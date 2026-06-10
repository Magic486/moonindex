// DefaultMap - A map that automatically provides a default value for missing keys
// Useful for counters, grouping, and accumulation operations

///|
pub struct DefaultMap[K, V] {
  // Internal storage
  map : IndexMap[K, V]
  // Default value generator
  default_fn : () -> V
}

///|
/// Create a new DefaultMap with a default value function
pub fn[K : Hash + Eq, V] DefaultMap::new(
  default_fn : () -> V,
) -> DefaultMap[K, V] {
  DefaultMap::{ map: IndexMap::new(), default_fn }
}

///|
/// Create a new DefaultMap with a constant default value
pub fn[K : Hash + Eq, V] DefaultMap::with_value(
  default_value : V,
) -> DefaultMap[K, V] {
  DefaultMap::new(fn() { default_value })
}

///|
/// Get value by key. If key doesn't exist, insert and return default value.
pub fn[K : Hash + Eq, V] DefaultMap::get(self : DefaultMap[K, V], key : K) -> V {
  match self.map.get(key) {
    Some(value) => value
    None => {
      let default_value = (self.default_fn)()
      self.map.insert(key, default_value)
      default_value
    }
  }
}

///|
/// Get value by key without inserting default. Returns None if key doesn't exist.
pub fn[K : Hash + Eq, V] DefaultMap::get_or_none(
  self : DefaultMap[K, V],
  key : K,
) -> V? {
  self.map.get(key)
}

///|
/// Insert a key-value pair
pub fn[K : Hash + Eq, V] DefaultMap::insert(
  self : DefaultMap[K, V],
  key : K,
  value : V,
) -> Unit {
  self.map.insert(key, value)
}

///|
/// Check if key exists
pub fn[K : Hash + Eq, V] DefaultMap::contains(
  self : DefaultMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// Remove a key
pub fn[K : Hash + Eq, V] DefaultMap::remove(
  self : DefaultMap[K, V],
  key : K,
) -> Bool {
  self.map.remove(key)
}

///|
/// Update value using a function. If key doesn't exist, use default value first.
pub fn[K : Hash + Eq, V] DefaultMap::update(
  self : DefaultMap[K, V],
  key : K,
  f : (V) -> V,
) -> Unit {
  let value = self.get(key)
  self.map.insert(key, f(value))
}

///|
/// Increment value (for numeric types). Creates default if key doesn't exist.
pub fn[K : Hash + Eq] DefaultMap::increment(
  self : DefaultMap[K, Int],
  key : K,
) -> Unit {
  self.update(key, fn(v) { v + 1 })
}

///|
/// Get the number of entries
pub fn[K, V] DefaultMap::length(self : DefaultMap[K, V]) -> Int {
  self.map.length()
}

///|
/// Check if the map is empty
pub fn[K, V] DefaultMap::is_empty(self : DefaultMap[K, V]) -> Bool {
  self.map.is_empty()
}

///|
/// Iterate over entries in insertion order
pub fn[K, V] DefaultMap::iter(self : DefaultMap[K, V]) -> Iter[(K, V)] {
  self.map.iter()
}

///|
/// Get all keys
pub fn[K, V] DefaultMap::keys(self : DefaultMap[K, V]) -> Array[K] {
  self.map.keys()
}

///|
/// Get all values
pub fn[K, V] DefaultMap::values(self : DefaultMap[K, V]) -> Array[V] {
  self.map.values()
}

///|
/// Clear all entries
pub fn[K, V] DefaultMap::clear(self : DefaultMap[K, V]) -> Unit {
  self.map.clear()
}

///|
/// Get the underlying IndexMap (for advanced operations)
pub fn[K, V] DefaultMap::to_index_map(
  self : DefaultMap[K, V],
) -> IndexMap[K, V] {
  self.map
}
