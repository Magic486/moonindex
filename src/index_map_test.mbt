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

///|
test "IndexMap filter" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)
  map.insert("d", 4)

  let filtered = map.filter(fn(k, v) { v % 2 == 0 })
  assert_eq(filtered.keys(), ["b", "d"])
  assert_eq(filtered.values(), [2, 4])
}

///|
test "IndexMap map values" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  let doubled = map.map(fn(v) { v * 2 })
  assert_eq(doubled.values(), [2, 4, 6])
}

///|
test "IndexMap fold" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  let sum = map.fold(0, fn(acc, k, v) { acc + v })
  assert_eq(sum, 6)
}

///|
test "IndexMap retain" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)
  map.insert("d", 4)

  map.retain(fn(k, v) { v % 2 == 0 })
  assert_eq(map.keys(), ["b", "d"])
  assert_eq(map.length(), 2)
}

///|
test "IndexMap swap" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  let success = map.swap("a", "b")
  assert_eq(success, true)
  assert_eq(map.get("a"), Some(2))
  assert_eq(map.get("b"), Some(1))
}

///|
test "IndexMap swap non-existent" {
  let map = IndexMap::new()
  map.insert("a", 1)

  let success = map.swap("a", "b")
  assert_eq(success, false)
}

///|
test "IndexMap get_or_default" {
  let map = IndexMap::new()
  map.insert("a", 1)

  assert_eq(map.get_or_default("a", 0), 1)
  assert_eq(map.get_or_default("b", 0), 0)
}

///|
test "IndexMap all" {
  let map = IndexMap::new()
  map.insert("a", 2)
  map.insert("b", 4)
  map.insert("c", 6)

  assert_eq(map.all(fn(k, v) { v % 2 == 0 }), true)
  assert_eq(map.all(fn(k, v) { v > 5 }), false)
}

///|
test "IndexMap any" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.any(fn(k, v) { v > 2 }), true)
  assert_eq(map.any(fn(k, v) { v > 5 }), false)
}

///|
test "IndexMap find" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.find(fn(k, v) { v == 2 }), Some(("b", 2)))
  assert_eq(map.find(fn(k, v) { v == 5 }), None)
}

///|
test "IndexMap count" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)
  map.insert("d", 4)

  assert_eq(map.count(fn(k, v) { v % 2 == 0 }), 2)
}

///|
test "IndexMap to_array" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  let arr = map.to_array()
  assert_eq(arr.length(), 2)
  assert_eq(arr[0], ("a", 1))
  assert_eq(arr[1], ("b", 2))
}

///|
test "IndexMap clone" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  let cloned = map.clone()
  assert_eq(cloned.keys(), ["a", "b"])
  assert_eq(cloned.values(), [1, 2])
}

///|
test "IndexMap reverse" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  map.reverse()
  assert_eq(map.keys(), ["c", "b", "a"])
}

///|
test "IndexMap shift" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  let success = map.shift("c", 0)
  assert_eq(success, true)
  assert_eq(map.keys(), ["c", "a", "b"])
}

///|
test "IndexMap nth_key" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.nth_key(0), Some("a"))
  assert_eq(map.nth_key(1), Some("b"))
  assert_eq(map.nth_key(2), None)
}

///|
test "IndexMap nth_value" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.nth_value(0), Some(1))
  assert_eq(map.nth_value(1), Some(2))
  assert_eq(map.nth_value(2), None)
}

///|
test "IndexMap contains_all" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.contains_all(["a", "b"]), true)
  assert_eq(map.contains_all(["a", "d"]), false)
}

///|
test "IndexMap contains_any" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.contains_any(["a", "c"]), true)
  assert_eq(map.contains_any(["c", "d"]), false)
}

///|
test "IndexMap merge" {
  let map1 = IndexMap::new()
  map1.insert("a", 1)
  map1.insert("b", 2)

  let map2 = IndexMap::new()
  map2.insert("b", 20)
  map2.insert("c", 3)

  map1.merge(map2)
  assert_eq(map1.get("a"), Some(1))
  assert_eq(map1.get("b"), Some(20))
  assert_eq(map1.get("c"), Some(3))
}

///|
test "IndexMap from_array" {
  let map = IndexMap::from_array([("a", 1), ("b", 2), ("a", 10)])

  assert_eq(map.get("a"), Some(10))
  assert_eq(map.get("b"), Some(2))
}

///|
test "IndexMap pop" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.pop(), Some(("b", 2)))
  assert_eq(map.length(), 1)
}

///|
test "IndexMap pop_first" {
  let map = IndexMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.pop_first(), Some(("a", 1)))
  assert_eq(map.length(), 1)
}
