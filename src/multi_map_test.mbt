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

///|
test "MultiMap get_last" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.get_last("a"), Some(3))
  assert_eq(map.get_last("b"), None)
}

///|
test "MultiMap get_nth" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.get_nth("a", 0), Some(1))
  assert_eq(map.get_nth("a", 1), Some(2))
  assert_eq(map.get_nth("a", 2), Some(3))
  assert_eq(map.get_nth("a", 3), None)
}

///|
test "MultiMap all_values_satisfy" {
  let map = MultiMap::new()
  map.insert("a", 2)
  map.insert("a", 4)
  map.insert("a", 6)

  assert_eq(map.all_values_satisfy("a", fn(v) { v % 2 == 0 }), true)
  assert_eq(map.all_values_satisfy("a", fn(v) { v > 5 }), false)
}

///|
test "MultiMap any_value_satisfies" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.any_value_satisfies("a", fn(v) { v == 2 }), true)
  assert_eq(map.any_value_satisfies("a", fn(v) { v == 5 }), false)
}

///|
test "MultiMap length" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.length(), 2)
}

///|
test "MultiMap value_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  assert_eq(map.value_count("a"), 3)
}

///|
test "MultiMap clone" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let cloned = map.clone()
  assert_eq(cloned.key_count(), 2)
  assert_eq(cloned.total_count(), 3)
}

///|
test "MultiMap merge" {
  let map1 = MultiMap::new()
  map1.insert("a", 1)
  map1.insert("b", 2)

  let map2 = MultiMap::new()
  map2.insert("b", 3)
  map2.insert("c", 4)

  map1.merge(map2)
  assert_eq(map1.get_count("a"), 1)
  assert_eq(map1.get_count("b"), 2)
  assert_eq(map1.get_count("c"), 1)
}

///|
test "MultiMap from_array" {
  let map = MultiMap::from_array([("a", 1), ("a", 2), ("b", 3)])

  assert_eq(map.get_count("a"), 2)
  assert_eq(map.get_count("b"), 1)
}

///|
test "MultiMap first_key" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.first_key(), Some("a"))
}

///|
test "MultiMap last_key" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.last_key(), Some("b"))
}

///|
test "MultiMap first_value" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.first_value(), Some(1))
}

///|
test "MultiMap last_value" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.last_value(), Some(2))
}

///|
test "MultiMap max_values_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  assert_eq(map.max_values_count(), 2)
}

///|
test "MultiMap min_values_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  assert_eq(map.min_values_count(), 1)
}

///|
test "MultiMap avg_values_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  assert_eq(map.avg_values_count(), 1.5)
}

///|
test "MultiMap all_keys_have_values" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.all_keys_have_values(), true)
}

///|
test "MultiMap set" {
  let map = MultiMap::new()
  map.set("a", [1, 2, 3])

  assert_eq(map.get_count("a"), 3)
}

///|
test "MultiMap append" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.append("a", [2, 3])

  assert_eq(map.get_count("a"), 3)
}

///|
test "MultiMap prepend" {
  let map = MultiMap::new()
  map.insert("a", 2)
  map.insert("a", 3)
  map.prepend("a", 1)

  assert_eq(map.get_first("a"), Some(1))
}

///|
test "MultiMap slice" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)
  map.insert("a", 4)

  let slice = map.slice("a", 1, 3)
  assert_eq(slice, [2, 3])
}

///|
test "MultiMap take" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  let taken = map.take("a", 2)
  assert_eq(taken, [1, 2])
}

///|
test "MultiMap drop" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("a", 3)

  let dropped = map.drop("a", 1)
  assert_eq(dropped, [2, 3])
}

///|
test "MultiMap flatten" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  assert_eq(map.flatten(), [1, 2, 3])
}

///|
test "MultiMap distinct_values" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 2)
  map.insert("b", 3)

  let distinct = map.distinct_values()
  assert_eq(distinct.length(), 3)
}

///|
test "MultiMap keys_by_count" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let counts = map.keys_by_count()
  assert_eq(counts.length(), 2)
}

///|
test "MultiMap stats" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let (keys, total, _avg, max, min) = map.stats()
  assert_eq(keys, 2)
  assert_eq(total, 3)
  assert_eq(max, 2)
  assert_eq(min, 1)
}

///|
test "MultiMap same_keys" {
  let map1 = MultiMap::new()
  map1.insert("a", 1)
  map1.insert("b", 2)

  let map2 = MultiMap::new()
  map2.insert("a", 3)
  map2.insert("b", 4)

  assert_eq(map1.same_keys(map2), true)
}

///|
test "MultiMap same_pairs" {
  let map1 = MultiMap::new()
  map1.insert("a", 1)
  map1.insert("a", 2)

  let map2 = MultiMap::new()
  map2.insert("a", 1)
  map2.insert("a", 2)

  assert_eq(map1.same_pairs(map2), true)
}

///|
test "MultiMap keys_with_most_values" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let keys = map.keys_with_most_values()
  assert_eq(keys, ["a"])
}

///|
test "MultiMap keys_with_least_values" {
  let map = MultiMap::new()
  map.insert("a", 1)
  map.insert("a", 2)
  map.insert("b", 3)

  let keys = map.keys_with_least_values()
  assert_eq(keys, ["b"])
}

///|
test "MultiMap empty_keys" {
  let map = MultiMap::new()
  map.insert("a", 1)

  assert_eq(map.empty_keys().length(), 0)
}
