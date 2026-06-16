// BiMap - Bidirectional mapping where both keys and values are unique
// Supports lookup by key or by value in O(1) time

///|
pub struct BiMap[K, V] {
  // Forward mapping: key -> value
  forward : IndexMap[K, V]
  // Reverse mapping: value -> key
  reverse : IndexMap[V, K]
}

///|
/// Create a new empty BiMap
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::new() -> BiMap[K, V] {
  { forward: IndexMap::new(), reverse: IndexMap::new() }
}

///|
/// Insert a key-value pair. Returns false if key or value already exists.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::insert(
  self : BiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  if self.forward.contains(key) || self.reverse.contains(value) {
    false
  } else {
    self.forward.insert(key, value)
    self.reverse.insert(value, key)
    true
  }
}

///|
/// Force insert, replacing any existing key or value
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::force_insert(
  self : BiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  // Remove old value if key exists
  match self.forward.get(key) {
    Some(old_value) => self.reverse.remove(old_value) |> ignore
    None => ()
  }
  // Remove old key if value exists
  match self.reverse.get(value) {
    Some(old_key) => self.forward.remove(old_key) |> ignore
    None => ()
  }
  self.forward.insert(key, value)
  self.reverse.insert(value, key)
}

///|
/// Get value by key
pub fn[K : Hash + Eq, V] BiMap::get(self : BiMap[K, V], key : K) -> V? {
  self.forward.get(key)
}

///|
/// Get key by value (inverse lookup)
pub fn[K, V : Hash + Eq] BiMap::get_key(self : BiMap[K, V], value : V) -> K? {
  self.reverse.get(value)
}

///|
/// Check if key exists
pub fn[K : Hash + Eq, V] BiMap::contains_key(
  self : BiMap[K, V],
  key : K,
) -> Bool {
  self.forward.contains(key)
}

///|
/// Check if value exists
pub fn[K, V : Hash + Eq] BiMap::contains_value(
  self : BiMap[K, V],
  value : V,
) -> Bool {
  self.reverse.contains(value)
}

///|
/// Remove by key. Returns true if removed.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::remove_by_key(
  self : BiMap[K, V],
  key : K,
) -> Bool {
  match self.forward.get(key) {
    Some(value) => {
      self.forward.remove(key) |> ignore
      self.reverse.remove(value) |> ignore
      true
    }
    None => false
  }
}

///|
/// Remove by value. Returns true if removed.
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::remove_by_value(
  self : BiMap[K, V],
  value : V,
) -> Bool {
  match self.reverse.get(value) {
    Some(key) => {
      self.forward.remove(key) |> ignore
      self.reverse.remove(value) |> ignore
      true
    }
    None => false
  }
}

///|
/// Get number of entries
pub fn[K, V] BiMap::length(self : BiMap[K, V]) -> Int {
  self.forward.length()
}

///|
/// Check if empty
pub fn[K, V] BiMap::is_empty(self : BiMap[K, V]) -> Bool {
  self.forward.is_empty()
}

///|
/// Get all keys
pub fn[K, V] BiMap::keys(self : BiMap[K, V]) -> Array[K] {
  self.forward.keys()
}

///|
/// Get all values
pub fn[K, V] BiMap::values(self : BiMap[K, V]) -> Array[V] {
  self.forward.values()
}

///|
/// Get all entries
pub fn[K, V] BiMap::to_array(self : BiMap[K, V]) -> Array[(K, V)] {
  self.forward.to_array()
}

///|
/// Iterate over entries
pub fn[K, V] BiMap::iter(self : BiMap[K, V]) -> Iter[(K, V)] {
  self.forward.iter()
}

///|
/// Get first entry
pub fn[K, V] BiMap::first(self : BiMap[K, V]) -> (K, V)? {
  self.forward.first()
}

///|
/// Get last entry
pub fn[K, V] BiMap::last(self : BiMap[K, V]) -> (K, V)? {
  self.forward.last()
}

///|
/// Get entry at position
pub fn[K, V] BiMap::get_at(self : BiMap[K, V], pos : Int) -> (K, V)? {
  self.forward.get_at(pos)
}

///|
/// Clear all entries
pub fn[K, V] BiMap::clear(self : BiMap[K, V]) -> Unit {
  self.forward.clear()
  self.reverse.clear()
}

///|
/// Create from array of pairs
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::from_array(
  arr : Array[(K, V)],
) -> BiMap[K, V] {
  let bimap = BiMap::new()
  for entry in arr.iter() {
    let (key, value) = entry
    bimap.insert(key, value) |> ignore
  }
  bimap
}

///|
/// Swap key and value (inverse the mapping)
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::inverse(
  self : BiMap[K, V],
) -> BiMap[V, K] {
  let result = BiMap::new()
  for entry in self.forward.iter() {
    let (key, value) = entry
    result.insert(value, key) |> ignore
  }
  result
}

///|
/// Check if all keys satisfy predicate
pub fn[K, V] BiMap::all_keys(self : BiMap[K, V], f : (K) -> Bool) -> Bool {
  self.forward.keys().all(f)
}

///|
/// Check if all values satisfy predicate
pub fn[K, V] BiMap::all_values(self : BiMap[K, V], f : (V) -> Bool) -> Bool {
  self.forward.values().all(f)
}

///|
/// Check if any key satisfies predicate
pub fn[K, V] BiMap::any_key(self : BiMap[K, V], f : (K) -> Bool) -> Bool {
  self.forward.keys().any(f)
}

///|
/// Check if any value satisfies predicate
pub fn[K, V] BiMap::any_value(self : BiMap[K, V], f : (V) -> Bool) -> Bool {
  self.forward.values().any(f)
}

///|
/// Clone the BiMap
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::clone(
  self : BiMap[K, V],
) -> BiMap[K, V] {
  let result = BiMap::new()
  for entry in self.forward.iter() {
    let (key, value) = entry
    result.insert(key, value) |> ignore
  }
  result
}

///|
/// Check if two BiMaps are equal
pub fn[K : Hash + Eq, V : Eq] BiMap::eq(
  self : BiMap[K, V],
  other : BiMap[K, V],
) -> Bool {
  if self.length() != other.length() {
    return false
  }
  for entry in self.forward.iter() {
    let (key, value) = entry
    match other.get(key) {
      Some(v) => if v != value { return false }
      None => return false
    }
  }
  true
}

///|
/// Map values to a new BiMap
pub fn[K : Hash + Eq, V, V2 : Hash + Eq] BiMap::map_values(
  self : BiMap[K, V],
  f : (V) -> V2,
) -> BiMap[K, V2] {
  let result = BiMap::new()
  for entry in self.forward.iter() {
    let (key, value) = entry
    result.insert(key, f(value)) |> ignore
  }
  result
}

///|
/// Filter entries by key predicate
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::filter_by_key(
  self : BiMap[K, V],
  f : (K) -> Bool,
) -> BiMap[K, V] {
  let result = BiMap::new()
  for entry in self.forward.iter() {
    let (key, value) = entry
    if f(key) {
      result.insert(key, value) |> ignore
    }
  }
  result
}

///|
/// Filter entries by value predicate
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::filter_by_value(
  self : BiMap[K, V],
  f : (V) -> Bool,
) -> BiMap[K, V] {
  let result = BiMap::new()
  for entry in self.forward.iter() {
    let (key, value) = entry
    if f(value) {
      result.insert(key, value) |> ignore
    }
  }
  result
}

///|
/// Fold over entries
pub fn[K, V, A] BiMap::fold(
  self : BiMap[K, V],
  init : A,
  f : (A, K, V) -> A,
) -> A {
  self.forward.fold(init, f)
}

///|
/// Find entry by key predicate
pub fn[K, V] BiMap::find_by_key(self : BiMap[K, V], f : (K) -> Bool) -> (K, V)? {
  for entry in self.forward.iter() {
    let (key, value) = entry
    if f(key) {
      return Some((key, value))
    }
  }
  None
}

///|
/// Find entry by value predicate
pub fn[K, V] BiMap::find_by_value(
  self : BiMap[K, V],
  f : (V) -> Bool,
) -> (K, V)? {
  for entry in self.forward.iter() {
    let (key, value) = entry
    if f(value) {
      return Some((key, value))
    }
  }
  None
}

///|
/// Get position of key
pub fn[K : Hash + Eq, V] BiMap::get_key_position(
  self : BiMap[K, V],
  key : K,
) -> Int? {
  self.forward.get_position(key)
}

///|
/// Get position of value
pub fn[K, V : Hash + Eq] BiMap::get_value_position(
  self : BiMap[K, V],
  value : V,
) -> Int? {
  self.reverse.get_position(value)
}

///|
/// Get nth key
pub fn[K, V] BiMap::nth_key(self : BiMap[K, V], n : Int) -> K? {
  self.forward.nth_key(n)
}

///|
/// Get nth value
pub fn[K, V] BiMap::nth_value(self : BiMap[K, V], n : Int) -> V? {
  self.forward.nth_value(n)
}

///|
/// Pop first entry
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::pop_first(
  self : BiMap[K, V],
) -> (K, V)? {
  match self.forward.pop_first() {
    Some((key, value)) => {
      self.reverse.remove(value) |> ignore
      Some((key, value))
    }
    None => None
  }
}

///|
/// Pop last entry
pub fn[K : Hash + Eq, V : Hash + Eq] BiMap::pop(self : BiMap[K, V]) -> (K, V)? {
  match self.forward.pop() {
    Some((key, value)) => {
      self.reverse.remove(value) |> ignore
      Some((key, value))
    }
    None => None
  }
}

///|
/// Check if key-value pair exists
pub fn[K : Hash + Eq, V : Eq] BiMap::contains_pair(
  self : BiMap[K, V],
  key : K,
  value : V,
) -> Bool {
  match self.forward.get(key) {
    Some(v) => v == value
    None => false
  }
}
