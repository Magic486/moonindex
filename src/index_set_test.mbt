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
