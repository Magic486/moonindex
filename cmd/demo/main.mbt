///|
fn main {
  // Demo program for moonindex library
  println("moonindex - Ordered Collections for MoonBit")

  // IndexMap demo
  let map = @src.IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)
  println("IndexMap keys: " + map.keys().to_string())

  // IndexSet demo
  let set = @src.IndexSet::new()
  let _ = set.insert("apple")
  let _ = set.insert("banana")
  let _ = set.insert("cherry")
  println("IndexSet elements: " + set.to_array().to_string())

  // MultiMap demo
  let multi = @src.MultiMap::new()
  multi.insert("fruits", "apple")
  multi.insert("fruits", "banana")
  multi.insert("vegetables", "carrot")
  println("MultiMap keys: " + multi.keys().to_string())

  // DefaultMap demo
  let counter = @src.DefaultMap::with_value(0)
  counter.increment("a")
  counter.increment("a")
  counter.increment("b")
  println("DefaultMap counter: " + counter.keys().to_string())
}
