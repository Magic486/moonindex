///|
test "IndexMap basic insert and get" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.get("a"), Some(1))
  assert_eq(map.get("b"), Some(2))
  assert_eq(map.get("c"), Some(3))
  assert_eq(map.get("d"), None)
}

///|
test "IndexMap insert order" {
  let map = IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)

  let keys = map.keys()
  assert_eq(keys, ["first", "second", "third"])
}

///|
test "IndexMap update existing key" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("a", 100)

  assert_eq(map.get("a"), Some(100))
  assert_eq(map.length(), 1)
}

///|
test "IndexMap remove" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.remove("b"), true)
  assert_eq(map.length(), 2)
  assert_eq(map.get("a"), Some(1))
  assert_eq(map.get("c"), Some(3))
  assert_eq(map.get("b"), None)
}

///|
test "IndexMap remove non-existent" {
  let map = IndexMap::new()
  map.insert("a", 1)

  assert_eq(map.remove("b"), false)
  assert_eq(map.length(), 1)
}

///|
test "IndexMap contains" {
  let map = IndexMap::new()
  map.insert("a", 1)

  assert_eq(map.contains("a"), true)
  assert_eq(map.contains("b"), false)
}

///|
test "IndexMap is_empty" {
  let map = IndexMap::new()
  assert_eq(map.is_empty(), true)

  map.insert("a", 1)
  assert_eq(map.is_empty(), false)
}

///|
test "IndexMap clear" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  map.clear()
  assert_eq(map.is_empty(), true)
  assert_eq(map.get("a"), None)
}

///|
test "IndexMap first and last" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.first(), Some(("a", 1)))
  assert_eq(map.last(), Some(("c", 3)))
}

///|
test "IndexMap get_at" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.get_at(0), Some(("a", 1)))
  assert_eq(map.get_at(1), Some(("b", 2)))
  assert_eq(map.get_at(2), Some(("c", 3)))
  assert_eq(map.get_at(3), None)
}

///|
test "IndexMap get_position" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.get_position("a"), Some(0))
  assert_eq(map.get_position("b"), Some(1))
  assert_eq(map.get_position("c"), Some(2))
  assert_eq(map.get_position("d"), None)
}

///|
test "IndexMap update" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.update("a", fn(v) { v + 10 })

  assert_eq(map.get("a"), Some(11))
}

///|
test "IndexMap values" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.values(), [1, 2, 3])
}

///|
test "IndexMap iteration order after remove" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)
  let _ = map.remove("b")
  map.insert("d", 4)

  let keys = map.keys()
  assert_eq(keys, ["a", "c", "d"])
}
