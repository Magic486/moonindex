///|
fn main {
  // Demo program for moonindex library
  println("moonindex - Ordered Collections for MoonBit")

  // IndexMap demo
  let map = @src.IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)
  println("IndexMap keys: \{to_repr(map.keys())}")

  // IndexSet demo
  let set = @src.IndexSet::new()
  let _ = set.insert("apple")
  let _ = set.insert("banana")
  let _ = set.insert("cherry")
  println("IndexSet elements: \{to_repr(set.to_array())}")

  // MultiMap demo
  let multi = @src.MultiMap::new()
  multi.insert("fruits", "apple")
  multi.insert("fruits", "banana")
  multi.insert("vegetables", "carrot")
  println("MultiMap keys: \{to_repr(multi.keys())}")

  // DefaultMap demo
  let counter = @src.DefaultMap::with_value(0)
  counter.increment("a")
  counter.increment("a")
  counter.increment("b")
  println("DefaultMap counter: \{to_repr(counter.keys())}")
}
