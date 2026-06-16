# moonindex

为 MoonBit 提供的有序集合库，在保持插入顺序的同时提供 O(1) 查找性能。

## 特性

- **IndexMap**: 有序 HashMap，保留插入顺序
- **IndexSet**: 有序 HashSet，支持 O(1) 成员检测
- **MultiMap**: 一对多映射，适用于分组操作
- **DefaultMap**: 自动初始化映射，为缺失键提供默认值
- **BiMap**: 双向映射，键和值均唯一，支持双向查找
- **OrderedMultiSet**: 有序多重集合，支持元素计数和重复检测

## 安装

```bash
moon add Magic486/moonindex
```

## 快速开始

### 1. 安装库

```bash
moon add Magic486/moonindex
```

### 2. 创建你的项目

```bash
moon new myproject
cd myproject
moon add Magic486/moonindex
```

### 3. 使用示例

```moonbit
fn main {
  // IndexMap - 有序 HashMap
  let map = @moonindex.IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  map.insert("third", 3)

  println(map.keys())  // ["first", "second", "third"]
  println(map.get("second"))  // Some(2)

  // IndexSet - 有序 HashSet
  let set = @moonindex.IndexSet::new()
  let _ = set.insert("apple")
  let _ = set.insert("banana")
  println(set.to_array())  // ["apple", "banana"]

  // MultiMap - 一对多映射
  let multi = @moonindex.MultiMap::new()
  multi.insert("fruits", "apple")
  multi.insert("fruits", "banana")
  println(multi.get("fruits"))  // Some(["apple", "banana"])

  // DefaultMap - 自动初始化计数器
  let counter = @moonindex.DefaultMap::with_value(0)
  counter.increment("apple")
  counter.increment("apple")
  println(counter.get("apple"))  // 2

  // BiMap - 双向映射
  let bimap = @moonindex.BiMap::new()
  bimap.insert("user_1", "session_abc") |> ignore
  bimap.insert("user_2", "session_def") |> ignore
  println(bimap.get("user_1"))  // Some("session_abc")
  println(bimap.get_key("session_def"))  // Some("user_2")

  // OrderedMultiSet - 有序多重集合
  let multiset = @moonindex.OrderedMultiSet::new()
  multiset.insert("file_a") |> ignore
  multiset.insert("file_b") |> ignore
  multiset.insert("file_a") |> ignore
  println(multiset.count("file_a"))  // 2
  println(multiset.duplicates())  // ["file_a"]
}
```

### 4. 运行测试

```bash
moon test
```

## API 文档

### IndexMap

有序 HashMap，保留插入顺序的同时提供 O(1) 查找。

```moonbit
let map = @moonindex.IndexMap::new()
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

有序 HashSet，保留插入顺序并支持 O(1) 成员检测。

```moonbit
let set = @moonindex.IndexSet::new()
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

一对多映射，适用于邻接表、HTTP 头和分组操作。

```moonbit
let multi = @moonindex.MultiMap::new()
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

自动初始化映射，为缺失键提供默认值。

```moonbit
let map = @moonindex.DefaultMap::with_value(0)
let map = @moonindex.DefaultMap::new(fn() { [] })
let value = map.get("key")        // V (自动初始化)
let value = map.get_or_none("key") // Option[V]
map.insert("key", 42)
map.increment("key")              // 适用于 Int 值
map.update("key", fn(v) { v + 1 })
let keys = map.keys()
let values = map.values()
for entry in map.iter() {          // Iter[(K, V)]
  // ...
}
```

### BiMap

双向映射，键和值均唯一，支持双向 O(1) 查找。

```moonbit
let bimap = @moonindex.BiMap::new()
bimap.insert("key", "value") |> ignore
let value = bimap.get("key")              // Option[V]
let key = bimap.get_key("value")          // Option[K]
let has_key = bimap.contains_key("key")
let has_value = bimap.contains_value("value")
let has_pair = bimap.contains_pair("key", "value")
let removed = bimap.remove_by_key("key")
let removed = bimap.remove_by_value("value")
let inverted = bimap.inverse()             // BiMap[V, K]
let keys = bimap.keys()
let values = bimap.values()
for entry in bimap.iter() {              // Iter[(K, V)]
  // ...
}
```

### OrderedMultiSet

有序多重集合，保留插入顺序，支持元素计数和重复检测。

```moonbit
let set = @moonindex.OrderedMultiSet::new()
set.insert("element") |> ignore
let count = set.count("element")
let exists = set.contains("element")
let removed = set.remove("element")
let removed = set.remove_all("element")
let duplicates = set.duplicates()
let uniques = set.uniques()
let most_common = set.most_common()
let least_common = set.least_common()
let union = set1.union(set2)
let intersection = set1.intersection(set2)
let difference = set1.difference(set2)
let arr = set.to_array()                 // Array[K] (展开重复)
let unique = set.unique_elements()       // Array[K] (去重)
for entry in set.iter() {                // Iter[(K, Int)]
  // ...
}
```

## 使用场景

### 词频统计

```moonbit
let counter = @moonindex.DefaultMap::with_value(0)
let words = ["apple", "banana", "apple", "cherry", "apple"]
for word in words.iter() {
  counter.increment(word)
}
println(counter.get("apple"))   // 3
println(counter.get("banana"))  // 1
```

### 按类别分组

```moonbit
let groups = @moonindex.DefaultMap::new(fn() { [] })
let items = [("fruit", "apple"), ("fruit", "banana"), ("veg", "carrot")]
for (cat, item) in items.iter() {
  let arr = groups.get(cat)
  arr.push(item)
  groups.insert(cat, arr)
}
println(groups.get("fruit"))  // ["apple", "banana"]
```

## 性能

所有结构均提供 O(1) 平均时间复杂度的插入、查找和删除操作。有序变体维护一个额外的数组来记录插入顺序，每个元素增加 O(1) 空间开销。

## 许可证

Apache-2.0

## 贡献

欢迎通过 [GitHub](https://github.com/Magic486/moonindex) 提交 Issues 和 Pull Requests。
