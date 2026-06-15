# CCF 项目申请 - moonindex

## 项目基本信息

- **项目名称**: moonindex
- **项目类型**: 基础数据结构与算法
- **项目描述**: 为 MoonBit 提供有序集合数据结构的库，包含 IndexMap、IndexSet、MultiMap、DefaultMap 四种核心数据结构
- **仓库地址**: https://github.com/Magic486/moonindex
- **mooncakes 地址**: Magic486/moonindex
- **版本**: 0.1.0
- **许可证**: Apache-2.0

## 项目背景

MoonBit 生态系统目前缺少有序集合数据结构。现有的 HashMap 和 HashSet 不保留插入顺序，这在很多实际场景（如配置管理、任务队列、HTTP 头处理）中造成不便。社区在 moonbitlang/x issue #140 中明确提出了对 MultiMap 和 DefaultMap 的需求。

本项目参考 Rust 的 `indexmap` crate，为 MoonBit 提供一套完整的有序集合库，填补了生态空白。

## 技术实现

### 核心数据结构

1. **IndexMap** - 有序 HashMap
   - 内部使用 Array 维护插入顺序
   - 使用 HashMap 提供 O(1) 查找
   - 支持位置访问、过滤、映射、折叠等函数式操作
   - 行数: ~500 行

2. **IndexSet** - 有序 HashSet
   - 基于 IndexMap 实现，以 Unit 作为值
   - 支持集合运算（并集、交集、差集、对称差集）
   - 支持子集/超集判断、不相交判断
   - 行数: ~380 行

3. **MultiMap** - 一对多映射
   - 基于 IndexMap 实现，值为 Array
   - 支持 HTTP 头、邻接表、分组操作等场景
   - 提供去重、排序、统计等高级功能
   - 行数: ~830 行

4. **DefaultMap** - 自动初始化映射
   - 基于 IndexMap 实现，提供默认值函数
   - 支持计数器、累加器等模式
   - 提供数值运算（increment、decrement、add 等）
   - 行数: ~530 行

### 测试覆盖

- 总计 169 个测试用例，全部通过
- 覆盖基本操作、边界条件、错误处理
- 测试文件: 4 个（index_map_test.mbt、index_set_test.mbt、multi_map_test.mbt、default_map_test.mbt）

### 示例程序

- 10 个实际应用场景示例
- 覆盖词频统计、HTTP 头处理、任务调度、图邻接表等
- 每个示例独立运行，展示库的实际用法

## 创新点

1. **有序性保证**: 在 O(1) 查找性能的基础上保留插入顺序，填补了 MoonBit 生态空白
2. **丰富的 API**: 提供 50+ 公共方法，涵盖 CRUD、过滤、映射、折叠、集合运算等
3. **类型安全**: 充分利用 MoonBit 的类型系统和泛型约束
4. **零外部依赖**: 仅依赖 moonbitlang/core/hashmap
5. **实用设计**: 参考 Rust indexmap 的成熟 API 设计，同时适配 MoonBit 语言特性

## 项目状态

- [x] 核心数据结构实现
- [x] 全面测试覆盖
- [x] 示例程序
- [x] 文档（README.md + API 文档）
- [x] CI 配置（GitHub Actions）
- [x] 演示程序
- [x] 代码格式化（moon fmt）

## 提交历史

项目包含 11 个有意义的 commit：
1. init: project setup
2. feat: implement IndexMap
3. feat: implement IndexSet
4. feat: implement MultiMap
5. feat: implement DefaultMap
6. test: add comprehensive test suite
7. feat: add demo program
8. docs: add README
9. ci: add GitHub Actions
10. feat: extend with utility methods
11. chore: clean up and reduce examples

## 项目统计

- 总代码行数: ~4,520 行（src/ + cmd/ + examples/）
- 测试行数: ~1,837 行
- 核心代码行数: ~2,235 行
- 示例代码行数: ~415 行
- 文档行数: ~200 行
- 测试通过率: 100% (169/169)

## 使用方式

```bash
moon add moonbit-user/moonindex
```

```moonbit
fn main {
  let map = IndexMap::new()
  map.insert("first", 1)
  map.insert("second", 2)
  println(map.keys())  // ["first", "second"]
}
```

## 未来计划

1. 添加更多高级数据结构（如有序 MultiMap）
2. 性能优化（减少 Array 拷贝）
3. 支持 serde 序列化
4. 添加更多使用示例和教程

---

**申请人**: [你的名字]
**联系方式**: [你的邮箱]
**申请日期**: 2026-06-10
