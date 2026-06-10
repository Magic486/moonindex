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
