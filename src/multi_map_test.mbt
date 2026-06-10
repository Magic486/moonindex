///|
test "MultiMap basic insert and get" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let values_a = map.get("a")
  assert_eq(values_a, Some([1, 2]))

  let values_b = map.get("b")
  assert_eq(values_b, Some([3]))

  let values_c = map.get("c")
  assert_eq(values_c, None)
}

///|
test "MultiMap get_first" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)

  assert_eq(map.get_first("a"), Some(1))
  assert_eq(map.get_first("c"), None)
}

///|
test "MultiMap get_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.get_count("a"), 3)
  assert_eq(map.get_count("b"), 0)
}

///|
test "MultiMap contains" {
  let map = MultiMap::new()
  map.insert("a", 1)

  assert_eq(map.contains("a"), true)
  assert_eq(map.contains("b"), false)
}

///|
test "MultiMap contains_pair" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)

  assert_eq(map.contains_pair("a", 1), true)
  assert_eq(map.contains_pair("a", 2), true)
  assert_eq(map.contains_pair("a", 3), false)
  assert_eq(map.contains_pair("b", 1), false)
}

///|
test "MultiMap remove_all" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)

  assert_eq(map.remove_all("a"), true)
  assert_eq(map.contains("a"), false)
  assert_eq(map.get("a"), None)
}

///|
test "MultiMap remove_pair" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.remove_pair("a", 2), true)
  assert_eq(map.get_count("a"), 2)
  assert_eq(map.contains_pair("a", 2), false)
  assert_eq(map.contains_pair("a", 1), true)
  assert_eq(map.contains_pair("a", 3), true)
}

///|
test "MultiMap remove_pair removes key when empty" {
  let map = MultiMap::new()
  map.insert("a", 1)

  assert_eq(map.remove_pair("a", 1), true)
  assert_eq(map.contains("a"), false)
}

///|
test "MultiMap key_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.key_count(), 2)
}

///|
test "MultiMap total_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  assert_eq(map.total_count(), 3)
}

///|
test "MultiMap is_empty" {
  let map = MultiMap::new()
  assert_eq(map.is_empty(), true)

  map.insert("a", 1)
  assert_eq(map.is_empty(), false)
}

///|
test "MultiMap clear" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  map.clear()
  assert_eq(map.is_empty(), true)
  assert_eq(map.get("a"), None)
}

///|
test "MultiMap iter" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let count = map.iter().count()
  assert_eq(count, 2)
}

///|
test "MultiMap iter_flat" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let count = map.iter_flat().count()
  assert_eq(count, 3)
}

///|
test "MultiMap keys" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  let keys = map.keys()
  assert_eq(keys, ["a", "b"])
}

///|
test "MultiMap all_values" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let values = map.all_values()
  assert_eq(values, [1, 2, 3])
}

///|
test "MultiMap order preserved" {
  let map = MultiMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)

  let keys = map.keys()
  assert_eq(keys, ["first", "second", "third"])
}
