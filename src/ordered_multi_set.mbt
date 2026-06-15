// OrderedMultiSet - Ordered set that allows duplicate elements
// Maintains insertion order while allowing multiple occurrences of the same element

///|
pub struct OrderedMultiSet[K] {
  // Uses IndexMap internally to track element counts
  map : IndexMap[K, Int]
}

///|
/// Create a new empty OrderedMultiSet
pub fn[K : Hash + Eq] OrderedMultiSet::new() -> OrderedMultiSet[K] {
  OrderedMultiSet::{ map: IndexMap::new() }
}

///|
/// Insert an element. Returns new count of that element.
pub fn[K : Hash + Eq] OrderedMultiSet::insert(
  self : OrderedMultiSet[K],
  key : K,
) -> Int {
  match self.map.get(key) {
    Some(count) => {
      let new_count = count + 1
      self.map.insert(key, new_count)
      new_count
    }
    None => {
      self.map.insert(key, 1)
      1
    }
  }
}

///|
/// Remove one occurrence of an element. Returns true if element was removed.
pub fn[K : Hash + Eq] OrderedMultiSet::remove(
  self : OrderedMultiSet[K],
  key : K,
) -> Bool {
  match self.map.get(key) {
    Some(count) => {
      if count > 1 {
        self.map.insert(key, count - 1)
      } else {
        self.map.remove(key) |> ignore
      }
      true
    }
    None => false
  }
}

///|
/// Remove all occurrences of an element
pub fn[K : Hash + Eq] OrderedMultiSet::remove_all(
  self : OrderedMultiSet[K],
  key : K,
) -> Bool {
  self.map.remove(key)
}

///|
/// Check if element exists (at least once)
pub fn[K : Hash + Eq] OrderedMultiSet::contains(
  self : OrderedMultiSet[K],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// Get count of an element
pub fn[K : Hash + Eq] OrderedMultiSet::count(
  self : OrderedMultiSet[K],
  key : K,
) -> Int {
  match self.map.get(key) {
    Some(c) => c
    None => 0
  }
}

///|
/// Get total number of unique elements
pub fn[K] OrderedMultiSet::unique_length(self : OrderedMultiSet[K]) -> Int {
  self.map.length()
}

///|
/// Get total number of elements (including duplicates)
pub fn[K] OrderedMultiSet::total_length(self : OrderedMultiSet[K]) -> Int {
  let mut total = 0
  for entry in self.map.iter() {
    let (_, count) = entry
    total += count
  }
  total
}

///|
/// Check if empty
pub fn[K] OrderedMultiSet::is_empty(self : OrderedMultiSet[K]) -> Bool {
  self.map.is_empty()
}

///|
/// Get unique elements
pub fn[K] OrderedMultiSet::unique_elements(self : OrderedMultiSet[K]) -> Array[K] {
  self.map.keys()
}

///|
/// Get all elements (with duplicates expanded)
pub fn[K] OrderedMultiSet::to_array(self : OrderedMultiSet[K]) -> Array[K] {
  let result = []
  for entry in self.map.iter() {
    let (key, count) = entry
    for _i in 0..<count {
      result.push(key)
    }
  }
  result
}

///|
/// Iterate over unique elements with their counts
pub fn[K] OrderedMultiSet::iter(
  self : OrderedMultiSet[K],
) -> Iter[(K, Int)] {
  self.map.iter()
}

///|
/// Get first unique element
pub fn[K] OrderedMultiSet::first(self : OrderedMultiSet[K]) -> K? {
  match self.map.first() {
    Some((key, _)) => Some(key)
    None => None
  }
}

///|
/// Get last unique element
pub fn[K] OrderedMultiSet::last(self : OrderedMultiSet[K]) -> K? {
  match self.map.last() {
    Some((key, _)) => Some(key)
    None => None
  }
}

///|
/// Clear all elements
pub fn[K] OrderedMultiSet::clear(self : OrderedMultiSet[K]) -> Unit {
  self.map.clear()
}

///|
/// Create from array
pub fn[K : Hash + Eq] OrderedMultiSet::from_array(
  arr : Array[K],
) -> OrderedMultiSet[K] {
  let set = OrderedMultiSet::new()
  for key in arr.iter() {
    set.insert(key) |> ignore
  }
  set
}

///|
/// Get most common element
pub fn[K] OrderedMultiSet::most_common(
  self : OrderedMultiSet[K],
) -> K? {
  let mut max_count = 0
  let mut result = None
  for entry in self.map.iter() {
    let (key, count) = entry
    if count > max_count {
      max_count = count
      result = Some(key)
    }
  }
  result
}

///|
/// Get least common element
pub fn[K] OrderedMultiSet::least_common(
  self : OrderedMultiSet[K],
) -> K? {
  let mut min_count = 999999
  let mut result = None
  for entry in self.map.iter() {
    let (key, count) = entry
    if count < min_count {
      min_count = count
      result = Some(key)
    }
  }
  result
}

///|
/// Get elements with count > 1
pub fn[K] OrderedMultiSet::duplicates(
  self : OrderedMultiSet[K],
) -> Array[K] {
  let result = []
  for entry in self.map.iter() {
    let (key, count) = entry
    if count > 1 {
      result.push(key)
    }
  }
  result
}

///|
/// Get unique elements (count == 1)
pub fn[K] OrderedMultiSet::uniques(
  self : OrderedMultiSet[K],
) -> Array[K] {
  let result = []
  for entry in self.map.iter() {
    let (key, count) = entry
    if count == 1 {
      result.push(key)
    }
  }
  result
}

///|
/// Filter elements by count
pub fn[K : Hash + Eq] OrderedMultiSet::filter_by_count(
  self : OrderedMultiSet[K],
  f : (Int) -> Bool,
) -> OrderedMultiSet[K] {
  let result = OrderedMultiSet::new()
  for entry in self.map.iter() {
    let (key, count) = entry
    if f(count) {
      for _i in 0..<count {
        result.insert(key) |> ignore
      }
    }
  }
  result
}

///|
/// Map elements to a new type
pub fn[K, K2 : Hash + Eq] OrderedMultiSet::map(
  self : OrderedMultiSet[K],
  f : (K) -> K2,
) -> OrderedMultiSet[K2] {
  let result = OrderedMultiSet::new()
  for entry in self.map.iter() {
    let (key, count) = entry
    let new_key = f(key)
    for _i in 0..<count {
      result.insert(new_key) |> ignore
    }
  }
  result
}

///|
/// Fold over unique elements
pub fn[K, A] OrderedMultiSet::fold(
  self : OrderedMultiSet[K],
  init : A,
  f : (A, K, Int) -> A,
) -> A {
  self.map.fold(init, f)
}

///|
/// Check if all unique elements satisfy predicate
pub fn[K] OrderedMultiSet::all(
  self : OrderedMultiSet[K],
  f : (K) -> Bool,
) -> Bool {
  for entry in self.map.iter() {
    let (key, _) = entry
    if !f(key) {
      return false
    }
  }
  true
}

///|
/// Check if any unique element satisfies predicate
pub fn[K] OrderedMultiSet::any(
  self : OrderedMultiSet[K],
  f : (K) -> Bool,
) -> Bool {
  for entry in self.map.iter() {
    let (key, _) = entry
    if f(key) {
      return true
    }
  }
  false
}

///|
/// Clone the set
pub fn[K : Hash + Eq] OrderedMultiSet::clone(
  self : OrderedMultiSet[K],
) -> OrderedMultiSet[K] {
  let result = OrderedMultiSet::new()
  for entry in self.map.iter() {
    let (key, count) = entry
    for _i in 0..<count {
      result.insert(key) |> ignore
    }
  }
  result
}

///|
/// Union with another OrderedMultiSet (max counts)
pub fn[K : Hash + Eq] OrderedMultiSet::union(
  self : OrderedMultiSet[K],
  other : OrderedMultiSet[K],
) -> OrderedMultiSet[K] {
  let result = self.clone()
  for entry in other.map.iter() {
    let (key, count) = entry
    let current = result.count(key)
    let max_count = if count > current { count } else { current }
    result.map.insert(key, max_count)
  }
  result
}

///|
/// Intersection (min counts)
pub fn[K : Hash + Eq] OrderedMultiSet::intersection(
  self : OrderedMultiSet[K],
  other : OrderedMultiSet[K],
) -> OrderedMultiSet[K] {
  let result = OrderedMultiSet::new()
  for entry in self.map.iter() {
    let (key, count1) = entry
    let count2 = other.count(key)
    if count2 > 0 {
      let min_count = if count1 < count2 { count1 } else { count2 }
      for _i in 0..<min_count {
        result.insert(key) |> ignore
      }
    }
  }
  result
}

///|
/// Difference (elements in self but not in other)
pub fn[K : Hash + Eq] OrderedMultiSet::difference(
  self : OrderedMultiSet[K],
  other : OrderedMultiSet[K],
) -> OrderedMultiSet[K] {
  let result = OrderedMultiSet::new()
  for entry in self.map.iter() {
    let (key, count1) = entry
    let count2 = other.count(key)
    if count1 > count2 {
      let diff = count1 - count2
      for _i in 0..<diff {
        result.insert(key) |> ignore
      }
    }
  }
  result
}

///|
/// Check if subset (all elements of self are in other with at least same count)
pub fn[K : Hash + Eq] OrderedMultiSet::is_subset(
  self : OrderedMultiSet[K],
  other : OrderedMultiSet[K],
) -> Bool {
  for entry in self.map.iter() {
    let (key, count) = entry
    if other.count(key) < count {
      return false
    }
  }
  true
}

///|
/// Check if superset
pub fn[K : Hash + Eq] OrderedMultiSet::is_superset(
  self : OrderedMultiSet[K],
  other : OrderedMultiSet[K],
) -> Bool {
  other.is_subset(self)
}

///|
/// Get unique elements count
pub fn[K] OrderedMultiSet::unique_count(
  self : OrderedMultiSet[K],
) -> Int {
  self.map.length()
}

///|
/// Get total duplicates count
pub fn[K] OrderedMultiSet::total_duplicates(
  self : OrderedMultiSet[K],
) -> Int {
  let mut total = 0
  for entry in self.map.iter() {
    let (_, count) = entry
    if count > 1 {
      total += count - 1
    }
  }
  total
}

///|
/// Get element at position in unique elements
pub fn[K] OrderedMultiSet::get_at(
  self : OrderedMultiSet[K],
  pos : Int,
) -> K? {
  match self.map.get_at(pos) {
    Some((key, _)) => Some(key)
    None => None
  }
}

///|
/// Get position of element
pub fn[K : Hash + Eq] OrderedMultiSet::get_position(
  self : OrderedMultiSet[K],
  key : K,
) -> Int? {
  self.map.get_position(key)
}

///|
/// Pop first unique element
pub fn[K : Hash + Eq] OrderedMultiSet::pop_first(
  self : OrderedMultiSet[K],
) -> K? {
  match self.map.pop_first() {
    Some((key, _)) => Some(key)
    None => None
  }
}

///|
/// Pop last unique element
pub fn[K : Hash + Eq] OrderedMultiSet::pop(
  self : OrderedMultiSet[K],
) -> K? {
  match self.map.pop() {
    Some((key, _)) => Some(key)
    None => None
  }
}
