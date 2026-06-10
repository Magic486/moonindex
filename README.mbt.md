# moonindex

Ordered collection library for MoonBit, providing data structures that maintain insertion order while offering O(1) lookup performance.

## Features

- **IndexMap**: Ordered HashMap that preserves insertion order
- **IndexSet**: Ordered HashSet with O(1) membership test
- **MultiMap**: One-to-many mapping for grouping operations
- **DefaultMap**: Auto-initializing map with default values

## Installation

```bash
moon add moonbit-user/moonindex
```

## Quick Start

```moonbit
fn main {
  // IndexMap - ordered HashMap
  let map = IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)
  
  println(map.keys())
  println(map.get("second"))
  
  // IndexSet - ordered HashSet
  let set = IndexSet::new()
  let _ = set.insert("apple")
  let _ = set.insert("banana")
  println(set.to_array())
  
  // MultiMap - one-to-many mapping
  let multi = MultiMap::new()
  multi.insert("fruits", "apple")
  multi.insert("fruits", "banana")
  println(multi.get("fruits"))
  
  // DefaultMap - auto-initializing counter
  let counter = DefaultMap::with_value(0)
  counter.increment("apple")
  counter.increment("apple")
  println(counter.get("apple"))
}
```

## API Documentation

### IndexMap

Ordered HashMap that maintains insertion order while providing O(1) lookup.

```moonbit
let map = IndexMap::new()
map.insert("key", 42)
let value = map.get("key")        // Option[V]
let exists = map.contains("key")  // Bool
let removed = map.remove("key")   // Bool
let first = map.first()           // Option[(K, V)]
let last = map.last()             // Option[(K, V)]
let at = map.get_at(0)            // Option[(K, V)]
let pos = map.get_position("key") // Option[Int]
let keys = map.keys()             // Array[K]
let values = map.values()         // Array[V]
for entry in map.iter() {         // Iter[(K, V)]
  // ...
}
map.update("key", fn(v) { v + 1 })
map.clear()
```

### IndexSet

Ordered HashSet that maintains insertion order with O(1) membership test.

```moonbit
let set = IndexSet::new()
let is_new = set.insert("element")
let exists = set.contains("element")
let removed = set.remove("element")
let union = set1.union(set2)
let intersection = set1.intersection(set2)
let difference = set1.difference(set2)
let first = set.first()           // Option[K]
let last = set.last()             // Option[K]
let at = set.get_at(0)            // Option[K]
let pos = set.get_position("elem") // Option[Int]
let arr = set.to_array()          // Array[K]
for elem in set.iter() {          // Iter[K]
  // ...
}
```

### MultiMap

One-to-many mapping for adjacency lists, HTTP headers, and grouping operations.

```moonbit
let multi = MultiMap::new()
multi.insert("key", "value1")
multi.insert("key", "value2")
let values = multi.get("key")         // Option[Array[V]]
let first = multi.get_first("key")    // Option[V]
let count = multi.get_count("key")    // Int
let has_key = multi.contains("key")
let has_pair = multi.contains_pair("key", "value")
let removed = multi.remove_all("key")
let removed = multi.remove_pair("key", "value")
let keys = multi.keys()
let all_values = multi.all_values()
for entry in multi.iter() {           // Iter[(K, Array[V])]
  // ...
}
for pair in multi.iter_flat() {       // Iter[(K, V)]
  // ...
}
```

### DefaultMap

Auto-initializing map that provides default values for missing keys.

```moonbit
let map = DefaultMap::with_value(0)
let map = DefaultMap::new(fn() { [] })
let value = map.get("key")        // V (auto-initializes)
let value = map.get_or_none("key") // Option[V]
map.insert("key", 42)
map.increment("key")              // For Int values
map.update("key", fn(v) { v + 1 })
let keys = map.keys()
let values = map.values()
for entry in map.iter() {          // Iter[(K, V)]
  // ...
}
```

## Use Cases

### Word Frequency Counter

```moonbit
let counter = DefaultMap::with_value(0)
let words = ["apple", "banana", "apple", "cherry", "apple"]
for word in words.iter() {
  counter.increment(word)
}
println(counter.get("apple"))   // 3
println(counter.get("banana"))  // 1
```

### Grouping by Category

```moonbit
let groups = DefaultMap::new(fn() { [] })
let items = [("fruit", "apple"), ("fruit", "banana"), ("veg", "carrot")]
for (cat, item) in items.iter() {
  let arr = groups.get(cat)
  arr.push(item)
  groups.insert(cat, arr)
}
println(groups.get("fruit"))  // ["apple", "banana"]
```

## Performance

All structures provide O(1) average case for insertions, lookups, and removals. The ordered variants maintain an additional array for insertion order, which adds O(1) space overhead per element.

## License

Apache-2.0

## Contributing

Issues and pull requests are welcome at [GitHub](https://github.com/moonbit-user/moonindex).
