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

///|
/// Symmetric difference: elements in either set but not both
pub fn[K : Hash + Eq] IndexSet::symmetric_difference(
  self : IndexSet[K],
  other : IndexSet[K],
) -> IndexSet[K] {
  let result = self.difference(other)
  for k in other.iter() {
    if !self.contains(k) {
      result.insert(k) |> ignore
    }
  }
  result
}

///|
/// Check if this set is a subset of another
pub fn[K : Hash + Eq] IndexSet::is_subset(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  for k in self.iter() {
    if !other.contains(k) {
      return false
    }
  }
  true
}

///|
/// Check if this set is a superset of another
pub fn[K : Hash + Eq] IndexSet::is_superset(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  other.is_subset(self)
}

///|
/// Check if sets are disjoint (no common elements)
pub fn[K : Hash + Eq] IndexSet::is_disjoint(
  self : IndexSet[K],
  other : IndexSet[K],
) -> Bool {
  for k in self.iter() {
    if other.contains(k) {
      return false
    }
  }
  true
}

///|
/// Check if all elements satisfy the predicate
pub fn[K] IndexSet::all(self : IndexSet[K], f : (K) -> Bool) -> Bool {
  for k in self.iter() {
    if !f(k) {
      return false
    }
  }
  true
}

///|
/// Check if any element satisfies the predicate
pub fn[K] IndexSet::any(self : IndexSet[K], f : (K) -> Bool) -> Bool {
  for k in self.iter() {
    if f(k) {
      return true
    }
  }
  false
}

///|
/// Filter elements by predicate
pub fn[K : Hash + Eq] IndexSet::filter(
  self : IndexSet[K],
  f : (K) -> Bool,
) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    if f(k) {
      result.insert(k) |> ignore
    }
  }
  result
}

///|
/// Map elements to a new set
pub fn[K : Hash + Eq, W : Hash + Eq] IndexSet::map(
  self : IndexSet[K],
  f : (K) -> W,
) -> IndexSet[W] {
  let result = IndexSet::new()
  for k in self.iter() {
    result.insert(f(k)) |> ignore
  }
  result
}

///|
/// Fold over elements in insertion order
pub fn[K, A] IndexSet::fold(
  self : IndexSet[K],
  init : A,
  f : (A, K) -> A,
) -> A {
  let mut acc = init
  for k in self.iter() {
    acc = f(acc, k)
  }
  acc
}

///|
/// Find first element that satisfies the predicate
pub fn[K] IndexSet::find(self : IndexSet[K], f : (K) -> Bool) -> K? {
  for k in self.iter() {
    if f(k) {
      return Some(k)
    }
  }
  None
}

///|
/// Count elements that satisfy the predicate
pub fn[K] IndexSet::count(self : IndexSet[K], f : (K) -> Bool) -> Int {
  let mut count = 0
  for k in self.iter() {
    if f(k) {
      count = count + 1
    }
  }
  count
}

///|
/// Clone the set
pub fn[K : Hash + Eq] IndexSet::clone(self : IndexSet[K]) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    result.insert(k) |> ignore
  }
  result
}

///|
/// Reverse the order of elements
pub fn[K : Hash + Eq] IndexSet::reverse(self : IndexSet[K]) -> Unit {
  self.map.reverse()
}

///|
/// Get the nth element
pub fn[K] IndexSet::nth(self : IndexSet[K], n : Int) -> K? {
  self.get_at(n)
}

///|
/// Pop the last element
pub fn[K : Hash + Eq] IndexSet::pop(self : IndexSet[K]) -> K? {
  match self.last() {
    Some(k) => {
      self.remove(k) |> ignore
      Some(k)
    }
    None => None
  }
}

///|
/// Pop the first element
pub fn[K : Hash + Eq] IndexSet::pop_first(self : IndexSet[K]) -> K? {
  match self.first() {
    Some(k) => {
      self.remove(k) |> ignore
      Some(k)
    }
    None => None
  }
}

///|
/// Check if set contains all elements from an array
pub fn[K : Hash + Eq] IndexSet::contains_all(
  self : IndexSet[K],
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
/// Check if set contains any element from an array
pub fn[K : Hash + Eq] IndexSet::contains_any(
  self : IndexSet[K],
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
/// Create from array of elements
pub fn[K : Hash + Eq] IndexSet::from_array(self : Array[K]) -> IndexSet[K] {
  let result = IndexSet::new()
  for k in self.iter() {
    result.insert(k) |> ignore
  }
  result
}

///|
/// Get all elements as array (alias for to_array)
pub fn[K] IndexSet::elements(self : IndexSet[K]) -> Array[K] {
  self.to_array()
}

///|
/// Get the number of elements (alias for length)
pub fn[K] IndexSet::size(self : IndexSet[K]) -> Int {
  self.length()
}
