///|
test "root package facade exports collection types" {
  let map = @moonindex.IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  assert_true(map.keys() == ["first", "second"])
  assert_true(map.get("second") is Some(2))

  let set = @moonindex.IndexSet::new()
  let _ = set.insert("apple")
  let _ = set.insert("apple")
  assert_true(set.to_array() == ["apple"])

  let multi = @moonindex.MultiMap::new()
  multi.insert("headers", "Accept")
  multi.insert("headers", "Content-Type")
  assert_eq(multi.get_count("headers"), 2)

  let counter = @moonindex.DefaultMap::with_value(0)
  counter.increment("apple")
  assert_eq(counter.get("apple"), 1)

  let bimap = @moonindex.BiMap::new()
  bimap.insert("user", "session") |> ignore
  assert_true(bimap.get_key("session") is Some("user"))

  let multiset = @moonindex.OrderedMultiSet::new()
  multiset.insert("hash") |> ignore
  multiset.insert("hash") |> ignore
  assert_eq(multiset.count("hash"), 2)
}
