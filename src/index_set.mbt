// IndexSet - Ordered HashSet
// Maintains insertion order while providing O(1) membership test

///|
pub struct IndexSet[K] {
  // Uses IndexMap internally with Unit as value
  map : IndexMap[K, Unit]
}

///|
/// Create a new empty IndexSet
pub fn[K : Hash + Eq] IndexSet::new() -> IndexSet[K] {
  IndexSet::{ map: IndexMap::new() }
}

///|
/// Insert a key. Returns true if key was new, false if already existed.
pub fn[K : Hash + Eq] IndexSet::insert(self : IndexSet[K], key : K) -> Bool {
  if self.map.contains(key) {
    false
  } else {
    self.map.insert(key, ())
    true
  }
}

///|
/// Check if key exists in the set
pub fn[K : Hash + Eq] IndexSet::contains(self : IndexSet[K], key : K) -> Bool {
  self.map.contains(key)
}

///|
/// Remove a key. Returns true if key was removed, false if not found.
pub fn[K : Hash + Eq] IndexSet::remove(self : IndexSet[K], key : K) -> Bool {
  self.map.remove(key)
}

///|
/// Get the number of elements
pub fn[K] IndexSet::length(self : IndexSet[K]) -> Int {
  self.map.length()
}

///|
/// Check if the set is empty
pub fn[K] IndexSet::is_empty(self : IndexSet[K]) -> Bool {
  self.map.is_empty()
}

///|
/// Iterate over elements in insertion order
pub fn[K] IndexSet::iter(self : IndexSet[K]) -> Iter[K] {
  self.map.keys().iter()
}

///|
/// Get all elements in insertion order
pub fn[K] IndexSet::to_array(self : IndexSet[K]) -> Array[K] {
  self.map.keys()
}

///|
/// Get the first element (earliest inserted)
pub fn[K] IndexSet::first(self : IndexSet[K]) -> K? {
  match self.map.first() {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get the last element (most recently inserted)
pub fn[K] IndexSet::last(self : IndexSet[K]) -> K? {
  match self.map.last() {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get element at specific position
pub fn[K] IndexSet::get_at(self : IndexSet[K], pos : Int) -> K? {
  match self.map.get_at(pos) {
    Some((k, _)) => Some(k)
    None => None
  }
}

///|
/// Get position of an element in insertion order
pub fn[K : Hash + Eq] IndexSet::get_position(
  self : IndexSet[K],
  key : K,
) -> Int? {
  self.map.get_position(key)
}

///|
/// Clear all elements
pub fn[K] IndexSet::clear(self : IndexSet[K]) -> Unit {
  self.map.clear()
}

///|
/// Union with another set. Elements from other set are appended.
pub fn[K : Hash + Eq] IndexSet::union(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    result.insert(k) |> ignore
  }
  for k in other.iter() {
    result.insert(k) |> ignore
  }
  result
}

///|
/// Intersection with another set
pub fn[K : Hash + Eq] IndexSet::intersection(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    if other.contains(k) {
      result.insert(k) |> ignore
    }
  }
  result
}

///|
/// Difference: elements in self but not in other
pub fn[K : Hash + Eq] IndexSet::difference(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    if !other.contains(k) {
      result.insert(k) |> ignore
    }
  }
  result
}
