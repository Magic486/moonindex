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
  { map: IndexMap::new(), default_fn }
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

///|
/// Get the first entry
pub fn[K, V] DefaultMap::first(self : DefaultMap[K, V]) -> (K, V)? {
  self.map.first()
}

///|
/// Get the last entry
pub fn[K, V] DefaultMap::last(self : DefaultMap[K, V]) -> (K, V)? {
  self.map.last()
}

///|
/// Get entry at position
pub fn[K, V] DefaultMap::get_at(self : DefaultMap[K, V], pos : Int) -> (K, V)? {
  self.map.get_at(pos)
}

///|
/// Get position of key
pub fn[K : Hash + Eq, V] DefaultMap::get_position(
  self : DefaultMap[K, V],
  key : K,
) -> Int? {
  self.map.get_position(key)
}

///|
/// Decrement value (for numeric types)
pub fn[K : Hash + Eq] DefaultMap::decrement(
  self : DefaultMap[K, Int],
  key : K,
) -> Unit {
  self.update(key, fn(v) { v - 1 })
}

///|
/// Add a value (for numeric types)
pub fn[K : Hash + Eq] DefaultMap::add(
  self : DefaultMap[K, Int],
  key : K,
  value : Int,
) -> Unit {
  self.update(key, fn(v) { v + value })
}

///|
/// Subtract a value (for numeric types)
pub fn[K : Hash + Eq] DefaultMap::subtract(
  self : DefaultMap[K, Int],
  key : K,
  value : Int,
) -> Unit {
  self.update(key, fn(v) { v - value })
}

///|
/// Multiply a value (for numeric types)
pub fn[K : Hash + Eq] DefaultMap::multiply(
  self : DefaultMap[K, Int],
  key : K,
  value : Int,
) -> Unit {
  self.update(key, fn(v) { v * value })
}

///|
/// Divide a value (for numeric types)
pub fn[K : Hash + Eq] DefaultMap::divide(
  self : DefaultMap[K, Int],
  key : K,
  value : Int,
) -> Unit {
  self.update(key, fn(v) { v / value })
}

///|
/// Get the sum of all values (for numeric types)
pub fn[K] DefaultMap::sum(self : DefaultMap[K, Int]) -> Int {
  let mut total = 0
  for value in self.map.values().iter() {
    total = total + value
  }
  total
}

///|
/// Get the maximum value (for numeric types)
pub fn[K] DefaultMap::max(self : DefaultMap[K, Int]) -> Int? {
  if self.map.is_empty() {
    return None
  }
  let mut max_val = @int.MIN_VALUE
  for value in self.map.values().iter() {
    if value > max_val {
      max_val = value
    }
  }
  Some(max_val)
}

///|
/// Get the minimum value (for numeric types)
pub fn[K] DefaultMap::min(self : DefaultMap[K, Int]) -> Int? {
  if self.map.is_empty() {
    return None
  }
  let mut min_val = @int.MAX_VALUE
  for value in self.map.values().iter() {
    if value < min_val {
      min_val = value
    }
  }
  Some(min_val)
}

///|
/// Get the average value (for numeric types)
pub fn[K] DefaultMap::avg(self : DefaultMap[K, Int]) -> Double {
  if self.map.is_empty() {
    return 0.0
  }
  let total = self.sum()
  let count = self.map.length()
  total.to_double() / count.to_double()
}

///|
/// Filter entries by predicate
pub fn[K : Hash + Eq, V] DefaultMap::filter(
  self : DefaultMap[K, V],
  f : (K, V) -> Bool,
) -> DefaultMap[K, V] {
  let result = DefaultMap::new(self.default_fn)
  for entry in self.map.iter() {
    let (k, v) = entry
    if f(k, v) {
      result.insert(k, v)
    }
  }
  result
}

///|
/// Map values while preserving keys
pub fn[K : Hash + Eq, V, W] DefaultMap::map(
  self : DefaultMap[K, V],
  f : (V) -> W,
  default_fn : () -> W,
) -> DefaultMap[K, W] {
  let result = DefaultMap::new(default_fn)
  for entry in self.map.iter() {
    let (k, v) = entry
    result.insert(k, f(v))
  }
  result
}

///|
/// Fold over entries
pub fn[K, V, A] DefaultMap::fold(
  self : DefaultMap[K, V],
  init : A,
  f : (A, K, V) -> A,
) -> A {
  self.map.fold(init, f)
}

///|
/// Check if all entries satisfy predicate
pub fn[K, V] DefaultMap::all(
  self : DefaultMap[K, V],
  f : (K, V) -> Bool,
) -> Bool {
  self.map.all(f)
}

///|
/// Check if any entry satisfies predicate
pub fn[K, V] DefaultMap::any(
  self : DefaultMap[K, V],
  f : (K, V) -> Bool,
) -> Bool {
  self.map.any(f)
}

///|
/// Find first entry satisfying predicate
pub fn[K, V] DefaultMap::find(
  self : DefaultMap[K, V],
  f : (K, V) -> Bool,
) -> (K, V)? {
  self.map.find(f)
}

///|
/// Count entries satisfying predicate
pub fn[K, V] DefaultMap::count(
  self : DefaultMap[K, V],
  f : (K, V) -> Bool,
) -> Int {
  self.map.count(f)
}

///|
/// Clone the DefaultMap
pub fn[K : Hash + Eq, V] DefaultMap::clone(
  self : DefaultMap[K, V],
) -> DefaultMap[K, V] {
  let result = DefaultMap::new(self.default_fn)
  for entry in self.map.iter() {
    let (k, v) = entry
    result.insert(k, v)
  }
  result
}

///|
/// Merge another DefaultMap into this one
pub fn[K : Hash + Eq, V] DefaultMap::merge(
  self : DefaultMap[K, V],
  other : DefaultMap[K, V],
) -> Unit {
  for entry in other.map.iter() {
    let (k, v) = entry
    self.insert(k, v)
  }
}

///|
/// Get value or default without inserting
pub fn[K : Hash + Eq, V] DefaultMap::get_or(
  self : DefaultMap[K, V],
  key : K,
  default : V,
) -> V {
  match self.map.get(key) {
    Some(v) => v
    None => default
  }
}

///|
/// Swap values of two keys
pub fn[K : Hash + Eq, V] DefaultMap::swap(
  self : DefaultMap[K, V],
  key1 : K,
  key2 : K,
) -> Bool {
  self.map.swap(key1, key2)
}

///|
/// Reverse order of entries
pub fn[K : Hash + Eq, V] DefaultMap::reverse(self : DefaultMap[K, V]) -> Unit {
  self.map.reverse()
}

///|
/// Get entries as array
pub fn[K, V] DefaultMap::to_array(self : DefaultMap[K, V]) -> Array[(K, V)] {
  self.map.to_array()
}

///|
/// Create from array of key-value pairs
pub fn[K : Hash + Eq, V] DefaultMap::from_array(
  arr : Array[(K, V)],
  default_fn : () -> V,
) -> DefaultMap[K, V] {
  let result = DefaultMap::new(default_fn)
  for entry in arr.iter() {
    let (k, v) = entry
    result.insert(k, v)
  }
  result
}

///|
/// Get the nth key
pub fn[K, V] DefaultMap::nth_key(self : DefaultMap[K, V], n : Int) -> K? {
  self.map.nth_key(n)
}

///|
/// Get the nth value
pub fn[K, V] DefaultMap::nth_value(self : DefaultMap[K, V], n : Int) -> V? {
  self.map.nth_value(n)
}

///|
/// Pop the last entry
pub fn[K : Hash + Eq, V] DefaultMap::pop(self : DefaultMap[K, V]) -> (K, V)? {
  self.map.pop()
}

///|
/// Pop the first entry
pub fn[K : Hash + Eq, V] DefaultMap::pop_first(
  self : DefaultMap[K, V],
) -> (K, V)? {
  self.map.pop_first()
}

///|
/// Check if map contains all given keys
pub fn[K : Hash + Eq, V] DefaultMap::contains_all(
  self : DefaultMap[K, V],
  keys : Array[K],
) -> Bool {
  self.map.contains_all(keys)
}

///|
/// Check if map contains any of the given keys
pub fn[K : Hash + Eq, V] DefaultMap::contains_any(
  self : DefaultMap[K, V],
  keys : Array[K],
) -> Bool {
  self.map.contains_any(keys)
}

///|
/// Get the number of keys (alias for length)
pub fn[K, V] DefaultMap::key_count(self : DefaultMap[K, V]) -> Int {
  self.map.length()
}

///|
/// Get keys with values satisfying a condition
pub fn[K, V] DefaultMap::keys_with_value(
  self : DefaultMap[K, V],
  f : (V) -> Bool,
) -> Array[K] {
  let result = []
  for entry in self.map.iter() {
    let (k, v) = entry
    if f(v) {
      result.push(k)
    }
  }
  result
}

///|
/// Get values for keys satisfying a condition
pub fn[K, V] DefaultMap::values_for_keys(
  self : DefaultMap[K, V],
  f : (K) -> Bool,
) -> Array[V] {
  let result = []
  for entry in self.map.iter() {
    let (k, v) = entry
    if f(k) {
      result.push(v)
    }
  }
  result
}

///|
/// Transform all values
pub fn[K : Hash + Eq, V] DefaultMap::transform(
  self : DefaultMap[K, V],
  f : (V) -> V,
) -> Unit {
  for entry in self.map.iter() {
    let (k, v) = entry
    self.map.insert(k, f(v))
  }
}

///|
/// Get statistics for numeric values
pub fn[K] DefaultMap::stats(
  self : DefaultMap[K, Int],
) -> (Int, Int, Int, Double, Int) {
  (
    self.map.length(),
    self.sum(),
    self.max().unwrap_or(0),
    self.avg(),
    self.min().unwrap_or(0),
  )
}
