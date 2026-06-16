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
  { map: IndexMap::new() }
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

///|
/// Get the number of unique keys (alias for key_count)
pub fn[K, V] MultiMap::length(self : MultiMap[K, V]) -> Int {
  self.key_count()
}

///|
/// Get the number of values for a specific key (alias for get_count)
pub fn[K : Hash + Eq, V] MultiMap::value_count(
  self : MultiMap[K, V],
  key : K,
) -> Int {
  self.get_count(key)
}

///|
/// Get the last value for a key
pub fn[K : Hash + Eq, V] MultiMap::get_last(
  self : MultiMap[K, V],
  key : K,
) -> V? {
  match self.map.get(key) {
    Some(values) =>
      if values.length() > 0 {
        Some(values[values.length() - 1])
      } else {
        None
      }
    None => None
  }
}

///|
/// Get the nth value for a key
pub fn[K : Hash + Eq, V] MultiMap::get_nth(
  self : MultiMap[K, V],
  key : K,
  n : Int,
) -> V? {
  match self.map.get(key) {
    Some(values) =>
      if n >= 0 && n < values.length() {
        Some(values[n])
      } else {
        None
      }
    None => None
  }
}

///|
/// Check if all values for a key satisfy a predicate
pub fn[K : Hash + Eq, V] MultiMap::all_values_satisfy(
  self : MultiMap[K, V],
  key : K,
  f : (V) -> Bool,
) -> Bool {
  match self.map.get(key) {
    Some(values) => {
      for value in values.iter() {
        if !f(value) {
          return false
        }
      }
      true
    }
    None => true
  }
}

///|
/// Check if any value for a key satisfies a predicate
pub fn[K : Hash + Eq, V] MultiMap::any_value_satisfies(
  self : MultiMap[K, V],
  key : K,
  f : (V) -> Bool,
) -> Bool {
  match self.map.get(key) {
    Some(values) => {
      for value in values.iter() {
        if f(value) {
          return true
        }
      }
      false
    }
    None => false
  }
}

///|
/// Map values for each key
pub fn[K : Hash + Eq, V, W] MultiMap::map_values(
  self : MultiMap[K, V],
  f : (V) -> W,
) -> MultiMap[K, W] {
  let result = MultiMap::new()
  for entry in self.map.iter() {
    let (k, values) = entry
    let new_values = values.map(f)
    result.map.insert(k, new_values)
  }
  result
}

///|
/// Filter values for each key by predicate
pub fn[K : Hash + Eq, V] MultiMap::filter_values(
  self : MultiMap[K, V],
  f : (V) -> Bool,
) -> MultiMap[K, V] {
  let result = MultiMap::new()
  for entry in self.map.iter() {
    let (k, values) = entry
    let filtered = values.filter(f)
    if filtered.length() > 0 {
      result.map.insert(k, filtered)
    }
  }
  result
}

///|
/// Fold over all values for a key
pub fn[K : Hash + Eq, V, A] MultiMap::fold_values(
  self : MultiMap[K, V],
  key : K,
  init : A,
  f : (A, V) -> A,
) -> A {
  match self.map.get(key) {
    Some(values) => {
      let mut acc = init
      for value in values.iter() {
        acc = f(acc, value)
      }
      acc
    }
    None => init
  }
}

///|
/// Flatten all values into a single array
pub fn[K, V] MultiMap::flatten(self : MultiMap[K, V]) -> Array[V] {
  self.all_values()
}

///|
/// Get distinct values across all keys (removes duplicates)
pub fn[K, V : Hash + Eq] MultiMap::distinct_values(
  self : MultiMap[K, V],
) -> Array[V] {
  let result = []
  let seen = IndexSet::new()
  for value in self.all_values().iter() {
    if !seen.contains(value) {
      result.push(value)
      let _ = seen.insert(value)
    }
  }
  result
}

///|
/// Get keys sorted by value count
pub fn[K, V] MultiMap::keys_by_count(self : MultiMap[K, V]) -> Array[(K, Int)] {
  let result = []
  for entry in self.map.iter() {
    let (k, values) = entry
    result.push((k, values.length()))
  }
  result
}

///|
/// Clone the MultiMap
pub fn[K : Hash + Eq, V] MultiMap::clone(
  self : MultiMap[K, V],
) -> MultiMap[K, V] {
  let result = MultiMap::new()
  for entry in self.map.iter() {
    let (k, values) = entry
    result.map.insert(k, values.copy())
  }
  result
}

///|
/// Merge another MultiMap into this one
pub fn[K : Hash + Eq, V] MultiMap::merge(
  self : MultiMap[K, V],
  other : MultiMap[K, V],
) -> Unit {
  for entry in other.map.iter() {
    let (k, values) = entry
    for value in values.iter() {
      self.insert(k, value)
    }
  }
}

///|
/// Create from array of key-value pairs
pub fn[K : Hash + Eq, V] MultiMap::from_array(
  arr : Array[(K, V)],
) -> MultiMap[K, V] {
  let result = MultiMap::new()
  for entry in arr.iter() {
    let (k, v) = entry
    result.insert(k, v)
  }
  result
}

///|
/// Get the first key (in insertion order)
pub fn[K, V] MultiMap::first_key(self : MultiMap[K, V]) -> K? {
  match self.map.first() {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get the last key (in insertion order)
pub fn[K, V] MultiMap::last_key(self : MultiMap[K, V]) -> K? {
  match self.map.last() {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get the first value across all keys
pub fn[K, V] MultiMap::first_value(self : MultiMap[K, V]) -> V? {
  match self.map.first() {
    Some((_, values)) =>
      if values.length() > 0 {
        Some(values[0])
      } else {
        None
      }
    None => None
  }
}

///|
/// Get the last value across all keys
pub fn[K, V] MultiMap::last_value(self : MultiMap[K, V]) -> V? {
  match self.map.last() {
    Some((_, values)) =>
      if values.length() > 0 {
        Some(values[values.length() - 1])
      } else {
        None
      }
    None => None
  }
}

///|
/// Get the maximum number of values for any key
pub fn[K, V] MultiMap::max_values_count(self : MultiMap[K, V]) -> Int {
  let mut max_count = 0
  for entry in self.map.iter() {
    let (_, values) = entry
    if values.length() > max_count {
      max_count = values.length()
    }
  }
  max_count
}

///|
/// Get the minimum number of values for any key
pub fn[K, V] MultiMap::min_values_count(self : MultiMap[K, V]) -> Int {
  if self.map.is_empty() {
    return 0
  }
  let mut min_count = @int.MAX_VALUE
  for entry in self.map.iter() {
    let (_, values) = entry
    if values.length() < min_count {
      min_count = values.length()
    }
  }
  min_count
}

///|
/// Get average number of values per key
pub fn[K, V] MultiMap::avg_values_count(self : MultiMap[K, V]) -> Double {
  if self.map.is_empty() {
    return 0.0
  }
  let total = self.total_count()
  let keys = self.key_count()
  total.to_double() / keys.to_double()
}

///|
/// Remove duplicate values for each key (keeps first occurrence)
pub fn[K : Hash + Eq, V : Hash + Eq] MultiMap::dedup_values(
  self : MultiMap[K, V],
) -> Unit {
  for entry in self.map.iter() {
    let (k, values) = entry
    let seen = IndexSet::new()
    let unique = []
    for value in values.iter() {
      if !seen.contains(value) {
        let _ = seen.insert(value)
        unique.push(value)
      }
    }
    self.map.insert(k, unique)
  }
}

///|
/// Sort values for each key using a comparator
pub fn[K : Hash + Eq, V : Compare] MultiMap::sort_values(
  self : MultiMap[K, V],
) -> Unit {
  for entry in self.map.iter() {
    let (k, values) = entry
    values.sort()
    self.map.insert(k, values)
  }
}

///|
/// Reverse values for each key
pub fn[K : Hash + Eq, V] MultiMap::reverse_values(
  self : MultiMap[K, V],
) -> Unit {
  for entry in self.map.iter() {
    let (k, values) = entry
    let len = values.length()
    for i = 0; i < len / 2; i = i + 1 {
      let j = len - 1 - i
      let temp = values[i]
      values[i] = values[j]
      values[j] = temp
    }
    self.map.insert(k, values)
  }
}

///|
/// Get the most common value across all keys
pub fn[K, V : Hash + Eq] MultiMap::most_common_value(
  self : MultiMap[K, V],
) -> V? {
  if self.map.is_empty() {
    return None
  }
  let counts = DefaultMap::with_value(0)
  for value in self.all_values().iter() {
    counts.increment(value)
  }
  let mut max_count = 0
  let mut most_common = None
  for entry in counts.iter() {
    let (value, count) = entry
    if count > max_count {
      max_count = count
      most_common = Some(value)
    }
  }
  most_common
}

///|
/// Check if all keys have at least one value
pub fn[K, V] MultiMap::all_keys_have_values(self : MultiMap[K, V]) -> Bool {
  for entry in self.map.iter() {
    let (_, values) = entry
    if values.is_empty() {
      return false
    }
  }
  true
}

///|
/// Get keys with empty value arrays
pub fn[K, V] MultiMap::empty_keys(self : MultiMap[K, V]) -> Array[K] {
  let result = []
  for entry in self.map.iter() {
    let (k, values) = entry
    if values.is_empty() {
      result.push(k)
    }
  }
  result
}

///|
/// Get keys with the most values
pub fn[K, V] MultiMap::keys_with_most_values(self : MultiMap[K, V]) -> Array[K] {
  if self.map.is_empty() {
    return []
  }
  let max_count = self.max_values_count()
  let result = []
  for entry in self.map.iter() {
    let (k, values) = entry
    if values.length() == max_count {
      result.push(k)
    }
  }
  result
}

///|
/// Get keys with the least values
pub fn[K, V] MultiMap::keys_with_least_values(
  self : MultiMap[K, V],
) -> Array[K] {
  if self.map.is_empty() {
    return []
  }
  let min_count = self.min_values_count()
  let result = []
  for entry in self.map.iter() {
    let (k, values) = entry
    if values.length() == min_count {
      result.push(k)
    }
  }
  result
}

///|
/// Replace all values for a key
pub fn[K : Hash + Eq, V] MultiMap::set(
  self : MultiMap[K, V],
  key : K,
  values : Array[V],
) -> Unit {
  self.map.insert(key, values)
}

///|
/// Append values from another array to a key
pub fn[K : Hash + Eq, V] MultiMap::append(
  self : MultiMap[K, V],
  key : K,
  values : Array[V],
) -> Unit {
  for value in values.iter() {
    self.insert(key, value)
  }
}

///|
/// Prepend a value to a key's values
pub fn[K : Hash + Eq, V] MultiMap::prepend(
  self : MultiMap[K, V],
  key : K,
  value : V,
) -> Unit {
  match self.map.get(key) {
    Some(values) => {
      values.insert(0, value)
      self.map.insert(key, values)
    }
    None => self.insert(key, value)
  }
}

///|
/// Get a slice of values for a key
pub fn[K : Hash + Eq, V] MultiMap::slice(
  self : MultiMap[K, V],
  key : K,
  start : Int,
  end : Int,
) -> Array[V] {
  match self.map.get(key) {
    Some(values) => {
      let len = values.length()
      let actual_start = start.max(0)
      let actual_end = end.min(len)
      if actual_start >= actual_end {
        return []
      }
      let result = []
      for i = actual_start; i < actual_end; i = i + 1 {
        result.push(values[i])
      }
      result
    }
    None => []
  }
}

///|
/// Take the first n values from a key
pub fn[K : Hash + Eq, V] MultiMap::take(
  self : MultiMap[K, V],
  key : K,
  n : Int,
) -> Array[V] {
  match self.map.get(key) {
    Some(values) => {
      let actual_n = n.min(values.length())
      let result = []
      for i = 0; i < actual_n; i = i + 1 {
        result.push(values[i])
      }
      result
    }
    None => []
  }
}

///|
/// Drop the first n values from a key
pub fn[K : Hash + Eq, V] MultiMap::drop(
  self : MultiMap[K, V],
  key : K,
  n : Int,
) -> Array[V] {
  match self.map.get(key) {
    Some(values) => {
      let actual_n = n.min(values.length())
      let result = []
      for i = actual_n; i < values.length(); i = i + 1 {
        result.push(values[i])
      }
      result
    }
    None => []
  }
}

///|
/// Partition values by a predicate for each key
pub fn[K : Hash + Eq, V] MultiMap::partition(
  self : MultiMap[K, V],
  f : (V) -> Bool,
) -> (MultiMap[K, V], MultiMap[K, V]) {
  let matching = MultiMap::new()
  let not_matching = MultiMap::new()
  for entry in self.map.iter() {
    let (k, values) = entry
    for value in values.iter() {
      if f(value) {
        matching.insert(k, value)
      } else {
        not_matching.insert(k, value)
      }
    }
  }
  (matching, not_matching)
}

///|
/// Group values by a function for each key
pub fn[K : Hash + Eq, V, G : Hash + Eq] MultiMap::group_by(
  self : MultiMap[K, V],
  f : (V) -> G,
) -> MultiMap[K, Array[V]] {
  let result = MultiMap::new()
  for entry in self.map.iter() {
    let (k, values) = entry
    let groups = DefaultMap::new(fn() { [] })
    for value in values.iter() {
      let g = f(value)
      let arr = groups.get(g)
      arr.push(value)
      groups.insert(g, arr)
    }
    for group_entry in groups.iter() {
      let (_, arr) = group_entry
      result.insert(k, arr)
    }
  }
  result
}

///|
/// Get statistics about the MultiMap
pub fn[K, V] MultiMap::stats(
  self : MultiMap[K, V],
) -> (Int, Int, Double, Int, Int) {
  (
    self.key_count(),
    self.total_count(),
    self.avg_values_count(),
    self.max_values_count(),
    self.min_values_count(),
  )
}

///|
/// Check if two MultiMaps have the same keys
pub fn[K : Hash + Eq, V] MultiMap::same_keys(
  self : MultiMap[K, V],
  other : MultiMap[K, V],
) -> Bool {
  if self.key_count() != other.key_count() {
    return false
  }
  for key in self.keys().iter() {
    if !other.contains(key) {
      return false
    }
  }
  true
}

///|
/// Check if two MultiMaps have the same key-value pairs
pub fn[K : Hash + Eq, V : Eq] MultiMap::same_pairs(
  self : MultiMap[K, V],
  other : MultiMap[K, V],
) -> Bool {
  if !self.same_keys(other) {
    return false
  }
  for key in self.keys().iter() {
    let self_values = self.get(key)
    let other_values = other.get(key)
    match (self_values, other_values) {
      (Some(sv), Some(ov)) => {
        if sv.length() != ov.length() {
          return false
        }
        for i = 0; i < sv.length(); i = i + 1 {
          if sv[i] != ov[i] {
            return false
          }
        }
      }
      _ => return false
    }
  }
  true
}
