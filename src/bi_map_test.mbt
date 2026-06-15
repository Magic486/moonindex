///|
test "bimap create and insert" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  assert_eq(bimap.length(), 3)
  assert_eq(bimap.get("a"), Some(1))
  assert_eq(bimap.get("b"), Some(2))
  assert_eq(bimap.get("c"), Some(3))
  assert_eq(bimap.get("d"), None)
}

///|
test "bimap duplicate key or value rejected" {
  let bimap = @src.BiMap::new()
  assert_eq(bimap.insert("a", 1), true)
  assert_eq(bimap.insert("a", 2), false) // duplicate key
  assert_eq(bimap.insert("b", 1), false) // duplicate value
  assert_eq(bimap.length(), 1)
}

///|
test "bimap force insert" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.force_insert("a", 10)
  assert_eq(bimap.get("a"), Some(10))
  assert_eq(bimap.get_key(1), None)
  assert_eq(bimap.get_key(10), Some("a"))
  
  bimap.force_insert("b", 10)
  assert_eq(bimap.get("b"), Some(10))
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(10), Some("b"))
}

///|
test "bimap inverse lookup" {
  let bimap = @src.BiMap::new()
  bimap.insert("apple", "red") |> ignore
  bimap.insert("banana", "yellow") |> ignore
  bimap.insert("grape", "purple") |> ignore
  assert_eq(bimap.get_key("red"), Some("apple"))
  assert_eq(bimap.get_key("yellow"), Some("banana"))
  assert_eq(bimap.get_key("purple"), Some("grape"))
  assert_eq(bimap.get_key("blue"), None)
}

///|
test "bimap contains" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  assert_eq(bimap.contains_key("a"), true)
  assert_eq(bimap.contains_key("b"), false)
  assert_eq(bimap.contains_value(1), true)
  assert_eq(bimap.contains_value(2), false)
  assert_eq(bimap.contains_pair("a", 1), true)
  assert_eq(bimap.contains_pair("a", 2), false)
}

///|
test "bimap remove by key" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  assert_eq(bimap.remove_by_key("a"), true)
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(1), None)
  assert_eq(bimap.length(), 1)
  assert_eq(bimap.remove_by_key("c"), false)
}

///|
test "bimap remove by value" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  assert_eq(bimap.remove_by_value(1), true)
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(1), None)
  assert_eq(bimap.length(), 1)
  assert_eq(bimap.remove_by_value(3), false)
}

///|
test "bimap clear" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.clear()
  assert_eq(bimap.is_empty(), true)
  assert_eq(bimap.length(), 0)
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(1), None)
}

///|
test "bimap keys and values" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  let keys = bimap.keys()
  let values = bimap.values()
  assert_eq(keys, ["a", "b", "c"])
  assert_eq(values, [1, 2, 3])
}

///|
test "bimap to array" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  let arr = bimap.to_array()
  assert_eq(arr.length(), 2)
  assert_eq(arr[0], ("a", 1))
  assert_eq(arr[1], ("b", 2))
}

///|
test "bimap from array" {
  let bimap = @src.BiMap::from_array([("a", 1), ("b", 2), ("c", 3)])
  assert_eq(bimap.length(), 3)
  assert_eq(bimap.get("a"), Some(1))
  assert_eq(bimap.get_key(2), Some("b"))
}

///|
test "bimap first and last" {
  let bimap = @src.BiMap::new()
  assert_eq(bimap.first(), None)
  assert_eq(bimap.last(), None)
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  assert_eq(bimap.first(), Some(("a", 1)))
  assert_eq(bimap.last(), Some(("b", 2)))
}

///|
test "bimap get at position" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  assert_eq(bimap.get_at(0), Some(("a", 1)))
  assert_eq(bimap.get_at(1), Some(("b", 2)))
  assert_eq(bimap.get_at(2), None)
}

///|
test "bimap inverse" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  let inverted = bimap.inverse()
  assert_eq(inverted.get(1), Some("a"))
  assert_eq(inverted.get(2), Some("b"))
  assert_eq(inverted.get_key("a"), Some(1))
}

///|
test "bimap all and any" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  assert_eq(bimap.all_keys(fn(k) { k.length() == 1 }), true)
  assert_eq(bimap.all_values(fn(v) { v > 0 }), true)
  assert_eq(bimap.all_values(fn(v) { v > 2 }), false)
  assert_eq(bimap.any_key(fn(k) { k == "b" }), true)
  assert_eq(bimap.any_value(fn(v) { v > 5 }), false)
}

///|
test "bimap clone" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  let cloned = bimap.clone()
  assert_eq(cloned.length(), 2)
  assert_eq(cloned.get("a"), Some(1))
  assert_eq(cloned.get_key(2), Some("b"))
  // Modify original, clone should not be affected
  bimap.remove_by_key("a") |> ignore
  assert_eq(cloned.get("a"), Some(1))
}

///|
test "bimap map values" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  let doubled = bimap.map_values(fn(v) { v * 2 })
  assert_eq(doubled.get("a"), Some(2))
  assert_eq(doubled.get("b"), Some(4))
  assert_eq(doubled.get_key(2), Some("a"))
}

///|
test "bimap filter by key" {
  let bimap = @src.BiMap::new()
  bimap.insert("apple", 1) |> ignore
  bimap.insert("banana", 2) |> ignore
  bimap.insert("avocado", 3) |> ignore
  let filtered = bimap.filter_by_key(fn(k) { k.starts_with("a") })
  assert_eq(filtered.length(), 2)
  assert_eq(filtered.get("apple"), Some(1))
  assert_eq(filtered.get("avocado"), Some(3))
  assert_eq(filtered.get("banana"), None)
}

///|
test "bimap filter by value" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 10) |> ignore
  bimap.insert("b", 20) |> ignore
  bimap.insert("c", 30) |> ignore
  let filtered = bimap.filter_by_value(fn(v) { v >= 20 })
  assert_eq(filtered.length(), 2)
  assert_eq(filtered.get("b"), Some(20))
  assert_eq(filtered.get("c"), Some(30))
  assert_eq(filtered.get("a"), None)
}

///|
test "bimap fold" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  let sum = bimap.fold(0, fn(acc, _k, v) { acc + v })
  assert_eq(sum, 6)
}

///|
test "bimap find by key" {
  let bimap = @src.BiMap::new()
  bimap.insert("apple", 1) |> ignore
  bimap.insert("banana", 2) |> ignore
  let found = bimap.find_by_key(fn(k) { k.starts_with("b") })
  assert_eq(found, Some(("banana", 2)))
  let not_found = bimap.find_by_key(fn(k) { k.starts_with("z") })
  assert_eq(not_found, None)
}

///|
test "bimap find by value" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 10) |> ignore
  bimap.insert("b", 20) |> ignore
  let found = bimap.find_by_value(fn(v) { v > 15 })
  assert_eq(found, Some(("b", 20)))
  let not_found = bimap.find_by_value(fn(v) { v > 50 })
  assert_eq(not_found, None)
}

///|
test "bimap position and nth" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  assert_eq(bimap.get_key_position("b"), Some(1))
  assert_eq(bimap.get_value_position(2), Some(1))
  assert_eq(bimap.nth_key(0), Some("a"))
  assert_eq(bimap.nth_value(1), Some(2))
  assert_eq(bimap.nth_key(5), None)
}

///|
test "bimap pop and pop_first" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  bimap.insert("c", 3) |> ignore
  let popped = bimap.pop()
  assert_eq(popped, Some(("c", 3)))
  assert_eq(bimap.get("c"), None)
  assert_eq(bimap.get_key(3), None)
  assert_eq(bimap.length(), 2)
  
  let first = bimap.pop_first()
  assert_eq(first, Some(("a", 1)))
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(1), None)
  assert_eq(bimap.length(), 1)
  
  let empty_pop = bimap.pop()
  assert_eq(bimap.pop(), None)
  assert_eq(bimap.pop_first(), None)
}

///|
test "bimap iteration" {
  let bimap = @src.BiMap::new()
  bimap.insert("a", 1) |> ignore
  bimap.insert("b", 2) |> ignore
  let mut count = 0
  for entry in bimap.iter() {
    let (key, value) = entry
    if key == "a" {
      assert_eq(value, 1)
    } else if key == "b" {
      assert_eq(value, 2)
    }
    count += 1
  }
  assert_eq(count, 2)
}

///|
test "bimap empty operations" {
  let bimap = @src.BiMap::new()
  assert_eq(bimap.is_empty(), true)
  assert_eq(bimap.length(), 0)
  assert_eq(bimap.get("a"), None)
  assert_eq(bimap.get_key(1), None)
  assert_eq(bimap.remove_by_key("a"), false)
  assert_eq(bimap.remove_by_value(1), false)
  assert_eq(bimap.keys(), [])
  assert_eq(bimap.values(), [])
  assert_eq(bimap.to_array(), [])
  assert_eq(bimap.first(), None)
  assert_eq(bimap.last(), None)
  assert_eq(bimap.get_at(0), None)
  assert_eq(bimap.nth_key(0), None)
  assert_eq(bimap.nth_value(0), None)
  assert_eq(bimap.get_key_position("a"), None)
  assert_eq(bimap.get_value_position(1), None)
  assert_eq(bimap.pop(), None)
  assert_eq(bimap.pop_first(), None)
  assert_eq(bimap.all_keys(fn(_) { true }), true)
  assert_eq(bimap.any_key(fn(_) { true }), false)
  assert_eq(bimap.find_by_key(fn(_) { true }), None)
  assert_eq(bimap.find_by_value(fn(_) { true }), None)
  let sum = bimap.fold(0, fn(acc, _k, v) { acc + v })
  assert_eq(sum, 0)
}
