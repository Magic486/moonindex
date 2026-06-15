# moonindex 人工验证指南

## 一、基础验证（必做）

### 1. 编译检查
```bash
cd C:\Users\yelfs\moonindex
$env:PATH = "C:\Users\yelfs\.moon\bin;$env:PATH"
moon check
moon build
moon fmt
moon info
```

**通过标准**：
- `moon check`: 0 errors
- `moon build`: 编译成功
- `moon fmt`: 无需要修改的文件（或执行后无变化）
- `moon info`: 0 errors

### 2. 测试运行
```bash
moon test
```

**通过标准**：
- Total tests: 169, passed: 169, failed: 0

### 3. 演示程序运行
```bash
moon run cmd/demo
```

**预期输出**：
```
IndexMap keys: ["first", "second", "third"]
IndexSet elements: ["apple", "banana"]
MultiMap keys: ["fruits"]
DefaultMap counter: ["apple"]
```

---

## 二、功能验证（逐项检查）

### IndexMap 验证清单

| 功能 | 验证代码 | 预期结果 |
|------|---------|---------|
| 插入顺序 | 依次插入 "a", "b", "c"，然后 keys() | ["a", "b", "c"] |
| 更新保持顺序 | 插入 "a"=1, "b"=2, 更新 "a"=10, 然后 keys() | ["a", "b"]（顺序不变） |
| 删除后索引 | 插入 "a", "b", "c", 删除 "b", 然后 get("c") | Some(原值)，位置变为1 |
| 空操作 | 空 map 调用 remove("x") | false |
| 越界访问 | 空 map 调用 get_at(0) | None |
| 重复插入 | 同一键插入两次，length() | 1（不是2） |

### IndexSet 验证清单

| 功能 | 验证代码 | 预期结果 |
|------|---------|---------|
| 插入唯一性 | 插入 "a" 两次，length() | 1 |
| 集合运算 | {1,2,3} union {3,4,5} | {1,2,3,4,5}（插入顺序） |
| 子集判断 | {1,2} is_subset {1,2,3} | true |
| 顺序保持 | 依次插入 3,1,2，to_array() | [3, 1, 2] |

### MultiMap 验证清单

| 功能 | 验证代码 | 预期结果 |
|------|---------|---------|
| 一对多 | insert("k", "v1"); insert("k", "v2"); get("k") | Some(["v1", "v2"]) |
| 删除单对 | 有 ["v1","v2"] 时 remove_pair("k", "v1") | 剩余 ["v2"] |
| 删除键 | remove_all("k") | 该键完全消失 |
| 空值键 | 存在键但无值时（手动构造） | 行为合理 |
| 统计 | key_count() vs total_count() | 后者 >= 前者 |

### DefaultMap 验证清单

| 功能 | 验证代码 | 预期结果 |
|------|---------|---------|
| 自动初始化 | 空 map 调用 get("x") | 返回默认值（如0） |
| 副作用 | get("x") 后调用 contains("x") | true（已自动插入） |
| 计数器 | increment("x") 两次，get("x") | 2 |
| 数学运算 | add("x", 5) 后 get("x") | 正确累加 |
| 自定义默认值 | DefaultMap::new(fn() { [] }) | 每次返回新数组 |

---

## 三、边界条件验证（重点）

### 必须测试的场景

```moonbit
// 1. 空集合操作
let empty_map = IndexMap::new()
assert_eq!(empty_map.is_empty(), true)
assert_eq!(empty_map.length(), 0)
assert_eq!(empty_map.first(), None)
assert_eq!(empty_map.last(), None)
assert_eq!(empty_map.pop(), None)

// 2. 单元素操作
let single = IndexMap::new()
single.insert("only", 42)
assert_eq!(single.first(), Some(("only", 42)))
assert_eq!(single.last(), Some(("only", 42)))
assert_eq!(single.pop(), Some(("only", 42)))
assert_eq!(single.is_empty(), true)

// 3. 重复键
let dup = IndexMap::new()
dup.insert("key", 1)
dup.insert("key", 2)
assert_eq!(dup.length(), 1)
assert_eq!(dup.get("key"), Some(2))

// 4. 删除后重建
let rebuild = IndexMap::new()
rebuild.insert("a", 1)
rebuild.insert("b", 2)
rebuild.remove("a")
rebuild.insert("c", 3)
assert_eq!(rebuild.keys(), ["b", "c"])

// 5. 大量数据
let large = IndexMap::new()
for i in 0..1000 {
  large.insert(i.to_string(), i)
}
assert_eq!(large.length(), 1000)
assert_eq!(large.get("500"), Some(500))
```

---

## 四、API 一致性验证

### 检查各结构的 API 是否统一

| 方法 | IndexMap | IndexSet | MultiMap | DefaultMap |
|------|---------|---------|---------|-----------|
| new() | ✅ | ✅ | ✅ | ✅ |
| insert() | ✅ | ✅ | ✅ | ✅（间接） |
| get() | ✅ | - | ✅ | ✅ |
| contains() | ✅ | ✅ | ✅ | ✅ |
| remove() | ✅ | ✅ | ✅ | ✅ |
| length() | ✅ | ✅ | ✅ | ✅ |
| is_empty() | ✅ | ✅ | ✅ | ✅ |
| clear() | ✅ | ✅ | ✅ | ✅ |
| iter() | ✅ | ✅ | ✅ | ✅ |
| keys() | ✅ | - | ✅ | ✅ |
| first() | ✅ | ✅ | ✅ | ✅ |
| last() | ✅ | ✅ | ✅ | ✅ |

**检查项**：
1. 同名方法行为是否一致？
2. 返回类型是否统一（如都用 Option 而不是 mix）？
3. 错误处理是否统一？

---

## 五、代码质量验证

### 1. 阅读核心文件
- `src/index_map.mbt` — 检查实现逻辑
- `src/index_set.mbt` — 检查是否基于 IndexMap 实现（DRY原则）
- `src/multi_map.mbt` — 检查是否基于 IndexMap 实现
- `src/default_map.mbt` — 检查是否基于 IndexMap 实现

### 2. 检查反模式
- [ ] 无 `unwrap()` 或 `unsafe` 操作
- [ ] 无裸递归（应用 `loop` 或迭代）
- [ ] 无内存泄漏（检查是否 `clear()` 彻底）
- [ ] 无重复代码（检查4个文件是否有重复逻辑）

### 3. 测试覆盖率
```bash
moon coverage analyze
```
检查报告中的未覆盖代码行。

---

## 六、对比验证（与竞品）

### 1. 与 `kesmeey/IndexMap` 对比
```bash
# 临时安装对比
moon add kesmeey/IndexMap
```

对比项：
- [ ] API 数量：谁的更多？
- [ ] 功能差异：谁支持 `swap`, `retain`, `shift`？
- [ ] 性能：插入 1000 个元素谁更快？

### 2. 与 Rust `indexmap` 对比
阅读 Rust indexmap 文档，检查：
- [ ] 是否遗漏了 Rust 版的关键方法？
- [ ] 命名是否遵循 Rust 惯例？

---

## 七、文档验证

### 1. README 检查
- [ ] 所有代码示例是否能直接复制运行？
- [ ] API 描述是否准确？
- [ ] 安装命令是否正确？

### 2. 文档一致性
- [ ] 代码中的 `///|` 注释是否与实现一致？
- [ ] 参数名和类型是否匹配？

---

## 八、性能验证（可选）

### 简单基准测试
```moonbit
// 在 main.mbt 中测试
fn main {
  let map = IndexMap::new()
  
  // 测试插入性能
  let start = @time.now()
  for i in 0..10000 {
    map.insert(i.to_string(), i)
  }
  let end = @time.now()
  println("Insert 10k: " + (end - start).to_string() + "ms")
  
  // 测试查找性能
  let start2 = @time.now()
  for i in 0..10000 {
    ignore(map.get(i.to_string()))
  }
  let end2 = @time.now()
  println("Lookup 10k: " + (end2 - start2).to_string() + "ms")
}
```

---

## 验证记录表

| 检查项 | 状态 | 备注 |
|--------|------|------|
| 编译通过 | ⬜ | |
| 测试通过 | ⬜ | |
| 演示运行 | ⬜ | |
| IndexMap 功能 | ⬜ | |
| IndexSet 功能 | ⬜ | |
| MultiMap 功能 | ⬜ | |
| DefaultMap 功能 | ⬜ | |
| 边界条件 | ⬜ | |
| API 一致性 | ⬜ | |
| 代码质量 | ⬜ | |
| 文档准确 | ⬜ | |

---

**验证完成后，把这份记录表填好发给我。如果发现任何 bug，告诉我具体的：**
1. **哪个文件**？
2. **哪行代码**？
3. **输入什么**？
4. **预期输出什么**？
5. **实际输出什么**？
