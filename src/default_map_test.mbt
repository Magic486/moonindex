///|
test "DefaultMap basic get and insert" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.get("a"), 1)
  assert_eq(map.get("b"), 2)
  assert_eq(map.get("c"), 0) // Returns default for new key
  assert_eq(map.contains("c"), true) // And inserts it
}

///|
test "DefaultMap get_or_none" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)

  assert_eq(map.get_or_none("a"), Some(1))
  assert_eq(map.get_or_none("b"), None)
}

///|
test "DefaultMap with function" {
  let map = DefaultMap::new(fn() { "default" })

  assert_eq(map.get("a"), "default")
  assert_eq(map.contains("a"), true)
}

///|
test "DefaultMap update" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.update("a", fn(v) { v + 10 })

  assert_eq(map.get("a"), 11)
}

///|
test "DefaultMap update non-existent" {
  let map = DefaultMap::with_value(0)
  map.update("a", fn(v) { v + 10 })

  assert_eq(map.get("a"), 10) // Gets default (0) then adds 10
}

///|
test "DefaultMap increment" {
  let map = DefaultMap::with_value(0)
  map.increment("a")
  map.increment("a")
  map.increment("a")

  assert_eq(map.get("a"), 3)
}

///|
test "DefaultMap contains" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)

  assert_eq(map.contains("a"), true)
  assert_eq(map.contains("b"), false)
}

///|
test "DefaultMap remove" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)

  assert_eq(map.remove("a"), true)
  assert_eq(map.contains("a"), false)
  assert_eq(map.remove("b"), false)
}

///|
test "DefaultMap length" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.length(), 2)
}

///|
test "DefaultMap is_empty" {
  let map = DefaultMap::with_value(0)
  assert_eq(map.is_empty(), true)

  map.insert("a", 1)
  assert_eq(map.is_empty(), false)
}

///|
test "DefaultMap clear" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  map.clear()
  assert_eq(map.is_empty(), true)
  assert_eq(map.get_or_none("a"), None)
}

///|
test "DefaultMap keys" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  let keys = map.keys()
  assert_eq(keys, ["a", "b", "c"])
}

///|
test "DefaultMap values" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  let values = map.values()
  assert_eq(values, [1, 2, 3])
}

///|
test "DefaultMap order preserved" {
  let map = DefaultMap::with_value(0)
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)

  let keys = map.keys()
  assert_eq(keys, ["first", "second", "third"])
}

///|
test "DefaultMap counter pattern" {
  let map = DefaultMap::with_value(0)

  // Count occurrences
  let words = ["apple", "banana", "apple", "cherry", "apple", "banana"]
  for word in words.iter() {
    map.increment(word)
  }

  assert_eq(map.get("apple"), 3)
  assert_eq(map.get("banana"), 2)
  assert_eq(map.get("cherry"), 1)
  assert_eq(map.get("orange"), 0) // New key gets default
}

///|
test "DefaultMap group_by pattern" {
  let map = DefaultMap::new(fn() { [] })

  // Group numbers by parity
  let numbers = [1, 2, 3, 4, 5, 6]
  for n in numbers.iter() {
    let key = if n % 2 == 0 { "even" } else { "odd" }
    let arr = map.get(key)
    arr.push(n)
    map.insert(key, arr)
  }

  assert_eq(map.get("odd"), [1, 3, 5])
  assert_eq(map.get("even"), [2, 4, 6])
}

///|
test "DefaultMap first and last" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.first(), Some(("a", 1)))
  assert_eq(map.last(), Some(("b", 2)))
}

///|
test "DefaultMap get_at" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.get_at(0), Some(("a", 1)))
  assert_eq(map.get_at(1), Some(("b", 2)))
  assert_eq(map.get_at(2), None)
}

///|
test "DefaultMap get_position" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.get_position("a"), Some(0))
  assert_eq(map.get_position("b"), Some(1))
}

///|
test "DefaultMap decrement" {
  let map = DefaultMap::with_value(0)
  map.decrement("a")
  map.decrement("a")

  assert_eq(map.get("a"), -2)
}

///|
test "DefaultMap add" {
  let map = DefaultMap::with_value(0)
  map.add("a", 5)
  map.add("a", 3)

  assert_eq(map.get("a"), 8)
}

///|
test "DefaultMap subtract" {
  let map = DefaultMap::with_value(0)
  map.subtract("a", 5)

  assert_eq(map.get("a"), -5)
}

///|
test "DefaultMap multiply" {
  let map = DefaultMap::with_value(2)
  map.multiply("a", 3)

  assert_eq(map.get("a"), 6)
}

///|
test "DefaultMap divide" {
  let map = DefaultMap::with_value(10)
  map.divide("a", 2)

  assert_eq(map.get("a"), 5)
}

///|
test "DefaultMap sum" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  assert_eq(map.sum(), 60)
}

///|
test "DefaultMap max" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 30)
  map.insert("c", 20)

  assert_eq(map.max(), Some(30))
}

///|
test "DefaultMap min" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 30)
  map.insert("c", 20)

  assert_eq(map.min(), Some(10))
}

///|
test "DefaultMap avg" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  assert_eq(map.avg(), 20.0)
}

///|
test "DefaultMap filter" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  let filtered = map.filter(fn(k, v) { v > 15 })
  assert_eq(filtered.keys(), ["b", "c"])
}

///|
test "DefaultMap map" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  let doubled = map.map(fn(v) { v * 2 }, fn() { 0 })
  assert_eq(doubled.values(), [20, 40])
}

///|
test "DefaultMap fold" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  let sum = map.fold(0, fn(acc, k, v) { acc + v })
  assert_eq(sum, 30)
}

///|
test "DefaultMap all" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  assert_eq(map.all(fn(k, v) { v > 5 }), true)
  assert_eq(map.all(fn(k, v) { v > 15 }), false)
}

///|
test "DefaultMap any" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  assert_eq(map.any(fn(k, v) { v > 15 }), true)
  assert_eq(map.any(fn(k, v) { v > 25 }), false)
}

///|
test "DefaultMap find" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  assert_eq(map.find(fn(k, v) { v == 20 }), Some(("b", 20)))
}

///|
test "DefaultMap count" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  assert_eq(map.count(fn(k, v) { v > 15 }), 2)
}

///|
test "DefaultMap clone" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  let cloned = map.clone()
  assert_eq(cloned.keys(), ["a", "b"])
  assert_eq(cloned.values(), [10, 20])
}

///|
test "DefaultMap merge" {
  let map1 = DefaultMap::with_value(0)
  map1.insert("a", 10)

  let map2 = DefaultMap::with_value(0)
  map2.insert("b", 20)

  map1.merge(map2)
  assert_eq(map1.get("a"), 10)
  assert_eq(map1.get("b"), 20)
}

///|
test "DefaultMap get_or" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)

  assert_eq(map.get_or("a", 5), 10)
  assert_eq(map.get_or("b", 5), 5)
}

///|
test "DefaultMap reverse" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  map.reverse()
  assert_eq(map.keys(), ["c", "b", "a"])
}

///|
test "DefaultMap to_array" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  let arr = map.to_array()
  assert_eq(arr.length(), 2)
}

///|
test "DefaultMap from_array" {
  let map = DefaultMap::from_array([("a", 1), ("b", 2)], fn() { 0 })

  assert_eq(map.get("a"), 1)
  assert_eq(map.get("b"), 2)
}

///|
test "DefaultMap pop" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.pop(), Some(("b", 2)))
  assert_eq(map.length(), 1)
}

///|
test "DefaultMap pop_first" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.pop_first(), Some(("a", 1)))
  assert_eq(map.length(), 1)
}

///|
test "DefaultMap contains_all" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)
  map.insert("c", 3)

  assert_eq(map.contains_all(["a", "b"]), true)
  assert_eq(map.contains_all(["a", "d"]), false)
}

///|
test "DefaultMap contains_any" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.contains_any(["a", "c"]), true)
  assert_eq(map.contains_any(["c", "d"]), false)
}

///|
test "DefaultMap key_count" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 1)
  map.insert("b", 2)

  assert_eq(map.key_count(), 2)
}

///|
test "DefaultMap keys_with_value" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  let keys = map.keys_with_value(fn(v) { v > 15 })
  assert_eq(keys, ["b", "c"])
}

///|
test "DefaultMap values_for_keys" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  let values = map.values_for_keys(fn(k) { k > "b" })
  assert_eq(values, [30])
}

///|
test "DefaultMap transform" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)

  map.transform(fn(v) { v + 5 })
  assert_eq(map.get("a"), 15)
  assert_eq(map.get("b"), 25)
}

///|
test "DefaultMap stats" {
  let map = DefaultMap::with_value(0)
  map.insert("a", 10)
  map.insert("b", 20)
  map.insert("c", 30)

  let (count, sum, max, avg, min) = map.stats()
  assert_eq(count, 3)
  assert_eq(sum, 60)
  assert_eq(max, 30)
  assert_eq(avg, 20.0)
  assert_eq(min, 10)
}
