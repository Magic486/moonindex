///|
test "IndexSet basic insert and contains" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.contains("a"), true)
  assert_eq(set.contains("b"), true)
  assert_eq(set.contains("c"), true)
  assert_eq(set.contains("d"), false)
}

///|
test "IndexSet insert duplicate" {
  let set = IndexSet::new()
  assert_eq(set.insert("a"), true)
  assert_eq(set.insert("a"), false)
  assert_eq(set.length(), 1)
}

///|
test "IndexSet remove" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.remove("b"), true)
  assert_eq(set.length(), 2)
  assert_eq(set.contains("a"), true)
  assert_eq(set.contains("c"), true)
  assert_eq(set.contains("b"), false)
}

///|
test "IndexSet remove non-existent" {
  let set = IndexSet::new()
  let _ = set.insert("a")

  assert_eq(set.remove("b"), false)
  assert_eq(set.length(), 1)
}

///|
test "IndexSet insert order" {
  let set = IndexSet::new()
  let _ = set.insert("first")
  let _ = set.insert("second")
  let _ = set.insert("third")

  let arr = set.to_array()
  assert_eq(arr, ["first", "second", "third"])
}

///|
test "IndexSet is_empty" {
  let set = IndexSet::new()
  assert_eq(set.is_empty(), true)

  let _ = set.insert("a")
  assert_eq(set.is_empty(), false)
}

///|
test "IndexSet clear" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  set.clear()
  assert_eq(set.is_empty(), true)
  assert_eq(set.contains("a"), false)
}

///|
test "IndexSet first and last" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.first(), Some("a"))
  assert_eq(set.last(), Some("c"))
}

///|
test "IndexSet get_at" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.get_at(0), Some("a"))
  assert_eq(set.get_at(1), Some("b"))
  assert_eq(set.get_at(2), Some("c"))
  assert_eq(set.get_at(3), None)
}

///|
test "IndexSet get_position" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.get_position("a"), Some(0))
  assert_eq(set.get_position("b"), Some(1))
  assert_eq(set.get_position("c"), Some(2))
  assert_eq(set.get_position("d"), None)
}

///|
test "IndexSet union" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("b")
  let _ = set2.insert("c")

  let union = set1.union(set2)
  assert_eq(union.contains("a"), true)
  assert_eq(union.contains("b"), true)
  assert_eq(union.contains("c"), true)
  assert_eq(union.length(), 3)
}

///|
test "IndexSet intersection" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("b")
  let _ = set2.insert("c")

  let intersection = set1.intersection(set2)
  assert_eq(intersection.contains("b"), true)
  assert_eq(intersection.contains("a"), false)
  assert_eq(intersection.contains("c"), false)
  assert_eq(intersection.length(), 1)
}

///|
test "IndexSet difference" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("b")
  let _ = set2.insert("c")

  let diff = set1.difference(set2)
  assert_eq(diff.contains("a"), true)
  assert_eq(diff.contains("b"), false)
  assert_eq(diff.contains("c"), false)
  assert_eq(diff.length(), 1)
}

///|
test "IndexSet symmetric_difference" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("b")
  let _ = set2.insert("c")

  let sym_diff = set1.symmetric_difference(set2)
  assert_eq(sym_diff.contains("a"), true)
  assert_eq(sym_diff.contains("b"), false)
  assert_eq(sym_diff.contains("c"), true)
}

///|
test "IndexSet is_subset" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("a")
  let _ = set2.insert("b")
  let _ = set2.insert("c")

  assert_eq(set1.is_subset(set2), true)
  assert_eq(set2.is_subset(set1), false)
}

///|
test "IndexSet is_superset" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")
  let _ = set1.insert("c")

  let set2 = IndexSet::new()
  let _ = set2.insert("a")
  let _ = set2.insert("b")

  assert_eq(set1.is_superset(set2), true)
  assert_eq(set2.is_superset(set1), false)
}

///|
test "IndexSet is_disjoint" {
  let set1 = IndexSet::new()
  let _ = set1.insert("a")
  let _ = set1.insert("b")

  let set2 = IndexSet::new()
  let _ = set2.insert("c")
  let _ = set2.insert("d")

  assert_eq(set1.is_disjoint(set2), true)

  let set3 = IndexSet::new()
  let _ = set3.insert("b")
  assert_eq(set1.is_disjoint(set3), false)
}

///|
test "IndexSet all" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.all(fn(k) { k.length() == 1 }), true)
  assert_eq(set.all(fn(k) { k == "a" }), false)
}

///|
test "IndexSet any" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.any(fn(k) { k == "a" }), true)
  assert_eq(set.any(fn(k) { k == "c" }), false)
}

///|
test "IndexSet filter" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  let filtered = set.filter(fn(k) { k > "b" })
  assert_eq(filtered.contains("c"), true)
  assert_eq(filtered.contains("a"), false)
}

///|
test "IndexSet fold" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  let concatenated = set.fold("", fn(acc, k) { acc + k })
  assert_eq(concatenated, "abc")
}

///|
test "IndexSet find" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.find(fn(k) { k == "b" }), Some("b"))
  assert_eq(set.find(fn(k) { k == "d" }), None)
}

///|
test "IndexSet count" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")
  let _ = set.insert("d")

  assert_eq(set.count(fn(k) { k.length() == 1 }), 4)
}

///|
test "IndexSet clone" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  let cloned = set.clone()
  assert_eq(cloned.to_array(), ["a", "b"])
}

///|
test "IndexSet reverse" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  set.reverse()
  assert_eq(set.to_array(), ["c", "b", "a"])
}

///|
test "IndexSet nth" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.nth(0), Some("a"))
  assert_eq(set.nth(1), Some("b"))
  assert_eq(set.nth(2), None)
}

///|
test "IndexSet pop" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.pop(), Some("b"))
  assert_eq(set.length(), 1)
}

///|
test "IndexSet pop_first" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.pop_first(), Some("a"))
  assert_eq(set.length(), 1)
}

///|
test "IndexSet contains_all" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")
  let _ = set.insert("c")

  assert_eq(set.contains_all(["a", "b"]), true)
  assert_eq(set.contains_all(["a", "d"]), false)
}

///|
test "IndexSet contains_any" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.contains_any(["a", "c"]), true)
  assert_eq(set.contains_any(["c", "d"]), false)
}

///|
test "IndexSet from_array" {
  let set = IndexSet::from_array(["a", "b", "c"])

  assert_eq(set.contains("a"), true)
  assert_eq(set.contains("b"), true)
  assert_eq(set.contains("c"), true)
}

///|
test "IndexSet elements" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.elements(), ["a", "b"])
}

///|
test "IndexSet size" {
  let set = IndexSet::new()
  let _ = set.insert("a")
  let _ = set.insert("b")

  assert_eq(set.size(), 2)
}
