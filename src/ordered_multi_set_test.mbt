///|
test "ordered_multi_set create and insert" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  assert_eq(set.count("a"), 2)
  assert_eq(set.count("b"), 1)
  assert_eq(set.count("c"), 0)
  assert_eq(set.unique_length(), 2)
  assert_eq(set.total_length(), 3)
  assert_eq(set.contains("a"), true)
  assert_eq(set.contains("c"), false)
}

///|
test "ordered_multi_set remove" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  assert_eq(set.remove("a"), true)
  assert_eq(set.count("a"), 2)
  assert_eq(set.remove("a"), true)
  assert_eq(set.count("a"), 1)
  assert_eq(set.remove("a"), true)
  assert_eq(set.count("a"), 0)
  assert_eq(set.contains("a"), false)
  assert_eq(set.remove("a"), false)
  assert_eq(set.remove("z"), false)
}

///|
test "ordered_multi_set remove_all" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  assert_eq(set.remove_all("a"), true)
  assert_eq(set.contains("a"), false)
  assert_eq(set.count("a"), 0)
  assert_eq(set.remove_all("z"), false)
  assert_eq(set.unique_length(), 1)
}

///|
test "ordered_multi_set clear" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  set.clear()
  assert_eq(set.is_empty(), true)
  assert_eq(set.count("a"), 0)
  assert_eq(set.unique_length(), 0)
}

///|
test "ordered_multi_set to array" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  let arr = set.to_array()
  assert_eq(arr.length(), 3)
  assert_eq(arr[0], "a")
  assert_eq(arr[1], "a")
  assert_eq(arr[2], "b")
}

///|
test "ordered_multi_set unique elements" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  let unique = set.unique_elements()
  assert_eq(unique.length(), 2)
  assert_eq(unique[0], "a")
  assert_eq(unique[1], "b")
}

///|
test "ordered_multi_set from array" {
  let set = @src.OrderedMultiSet::from_array(["a", "b", "a", "c", "b", "a"])
  assert_eq(set.count("a"), 3)
  assert_eq(set.count("b"), 2)
  assert_eq(set.count("c"), 1)
  assert_eq(set.unique_length(), 3)
  assert_eq(set.total_length(), 6)
}

///|
test "ordered_multi_set first and last" {
  let set = @src.OrderedMultiSet::new()
  assert_eq(set.first(), None)
  assert_eq(set.last(), None)
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  assert_eq(set.first(), Some("a"))
  assert_eq(set.last(), Some("b"))
}

///|
test "ordered_multi_set most and least common" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("c") |> ignore
  set.insert("c") |> ignore
  set.insert("c") |> ignore
  assert_eq(set.most_common(), Some("c"))
  assert_eq(set.least_common(), Some("b"))

  let empty = @src.OrderedMultiSet::new()
  assert_eq(empty.most_common(), None)
  assert_eq(empty.least_common(), None)
}

///|
test "ordered_multi_set duplicates and uniques" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("c") |> ignore
  set.insert("c") |> ignore
  set.insert("d") |> ignore
  let duplicates = set.duplicates()
  assert_eq(duplicates.length(), 2)
  assert_eq(duplicates.contains("a"), true)
  assert_eq(duplicates.contains("c"), true)

  let uniques = set.uniques()
  assert_eq(uniques.length(), 2)
  assert_eq(uniques.contains("b"), true)
  assert_eq(uniques.contains("d"), true)
}

///|
test "ordered_multi_set filter by count" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("c") |> ignore
  set.insert("c") |> ignore
  set.insert("c") |> ignore
  let filtered = set.filter_by_count(fn(c) { c >= 2 })
  assert_eq(filtered.contains("a"), true)
  assert_eq(filtered.contains("b"), false)
  assert_eq(filtered.contains("c"), true)
  assert_eq(filtered.count("a"), 2)
  assert_eq(filtered.count("c"), 3)
}

///|
test "ordered_multi_set map" {
  let set = @src.OrderedMultiSet::new()
  set.insert(1) |> ignore
  set.insert(2) |> ignore
  set.insert(1) |> ignore
  let mapped = set.map(fn(x) { x * 10 })
  assert_eq(mapped.count(10), 2)
  assert_eq(mapped.count(20), 1)
  assert_eq(mapped.total_length(), 3)
}

///|
test "ordered_multi_set fold" {
  let set = @src.OrderedMultiSet::new()
  set.insert(1) |> ignore
  set.insert(2) |> ignore
  set.insert(1) |> ignore
  let sum = set.fold(0, fn(acc, k, v) { acc + k * v })
  assert_eq(sum, 4) // 1*2 + 2*1 = 4
}

///|
test "ordered_multi_set union" {
  let set1 = @src.OrderedMultiSet::from_array(["a", "a", "b"])
  let set2 = @src.OrderedMultiSet::from_array(["a", "b", "b", "c"])
  let union = set1.union(set2)
  assert_eq(union.count("a"), 2)
  assert_eq(union.count("b"), 2)
  assert_eq(union.count("c"), 1)
}

///|
test "ordered_multi_set intersection" {
  let set1 = @src.OrderedMultiSet::from_array(["a", "a", "b"])
  let set2 = @src.OrderedMultiSet::from_array(["a", "b", "b"])
  let intersection = set1.intersection(set2)
  assert_eq(intersection.count("a"), 1)
  assert_eq(intersection.count("b"), 1)
  assert_eq(intersection.contains("c"), false)
}

///|
test "ordered_multi_set difference" {
  let set1 = @src.OrderedMultiSet::from_array(["a", "a", "b", "c"])
  let set2 = @src.OrderedMultiSet::from_array(["a", "b"])
  let diff = set1.difference(set2)
  assert_eq(diff.count("a"), 1)
  assert_eq(diff.count("c"), 1)
  assert_eq(diff.contains("b"), false)
}

///|
test "ordered_multi_set subset and superset" {
  let set1 = @src.OrderedMultiSet::from_array(["a", "b"])
  let set2 = @src.OrderedMultiSet::from_array(["a", "b", "c"])
  let set3 = @src.OrderedMultiSet::from_array(["a", "a", "b"])
  assert_eq(set1.is_subset(set2), true)
  assert_eq(set2.is_superset(set1), true)
  assert_eq(set3.is_subset(set2), false) // set3 has 2 a's, set2 has 1
}

///|
test "ordered_multi_set clone" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  let cloned = set.clone()
  assert_eq(cloned.count("a"), 2)
  assert_eq(cloned.count("b"), 1)
  set.remove("a") |> ignore
  assert_eq(cloned.count("a"), 2)
}

///|
test "ordered_multi_set get at and position" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  assert_eq(set.get_at(0), Some("a"))
  assert_eq(set.get_at(1), Some("b"))
  assert_eq(set.get_at(2), None)
  assert_eq(set.get_position("a"), Some(0))
  assert_eq(set.get_position("b"), Some(1))
  assert_eq(set.get_position("z"), None)
}

///|
test "ordered_multi_set pop" {
  let set = @src.OrderedMultiSet::new()
  set.insert("a") |> ignore
  set.insert("b") |> ignore
  set.insert("a") |> ignore
  assert_eq(set.pop(), Some("b"))
  assert_eq(set.contains("b"), false)
  assert_eq(set.pop_first(), Some("a"))
  assert_eq(set.contains("a"), false)
  assert_eq(set.is_empty(), true)
  assert_eq(set.pop(), None)
  assert_eq(set.pop_first(), None)
}

///|
test "ordered_multi_set empty" {
  let set = @src.OrderedMultiSet::new()
  assert_eq(set.is_empty(), true)
  assert_eq(set.unique_length(), 0)
  assert_eq(set.total_length(), 0)
  assert_eq(set.first(), None)
  assert_eq(set.last(), None)
  assert_eq(set.to_array(), [])
  assert_eq(set.unique_elements(), [])
  assert_eq(set.count("a"), 0)
  assert_eq(set.remove("a"), false)
  assert_eq(set.remove_all("a"), false)
  assert_eq(set.get_at(0), None)
  assert_eq(set.get_position("a"), None)
  assert_eq(set.most_common(), None)
  assert_eq(set.least_common(), None)
  assert_eq(set.duplicates(), [])
  assert_eq(set.uniques(), [])
  assert_eq(set.total_duplicates(), 0)
  assert_eq(set.unique_count(), 0)
  let sum = set.fold(0, fn(acc, _k, v) { acc + v })
  assert_eq(sum, 0)
}
