# MoonBit 开源项目申报书

**项目**：moonindex
**GitHub**：https://github.com/Magic486/moonindex
**GitLink**：https://www.gitlink.org.cn/Magic486/index

---

## 项目简介

做这个项目是因为实际开发中经常遇到顺序问题。MoonBit 标准库的 HashMap 和 HashSet 性能没问题，但遍历时的顺序完全不可控，这在处理配置文件、任务队列、HTTP 头这类场景时容易出问题。

我参考了 Rust 的 indexmap crate，给 MoonBit 写了一套有序集合库。核心思路是：内部用数组维护插入顺序，再用 HashMap 做索引，兼顾顺序和性能。

## 项目方向与适用场景

主要解决三类需求：

**有序映射**。读取配置文件时保留 key 的原始顺序，按创建顺序处理任务列表，这些都是 HashMap 做不到的。

**键值自动初始化**。统计词频时每次遇到新词都要判断 key 是否存在，按类别分组时每次都要检查分类是否初始化。DefaultMap 可以自动处理这些重复逻辑。

**一对多映射**。HTTP 头、邻接表、标签系统，一个 key 对多个 value 的场景。

**双向查找**。Session 管理、编码映射等需要双向查找的场景。

**重复计数**。文件去重、词频统计等需要统计元素出现次数的场景。

## 核心功能

1. **IndexMap**：有序 HashMap，支持位置访问、过滤、映射、折叠等操作。
2. **IndexSet**：有序 HashSet，支持并集、交集、差集。
3. **MultiMap**：一对多映射，值为数组，支持去重、排序。
4. **DefaultMap**：自动初始化映射，提供默认值函数。
5. **BiMap**：双向映射，键和值均唯一，支持双向 O(1) 查找。
6. **OrderedMultiSet**：有序多重集合，支持元素计数、重复检测、集合运算。

## 项目性质

原创项目。参考 Rust indexmap 的设计思路，但完全独立实现，适配 MoonBit 的类型系统和泛型约束。

## 现状

- 核心实现：约 3,000 行 MoonBit 代码
- 测试：225+ 个用例，全部通过
- 示例：13 个实际场景示例，并纳入 `moon test`
- 文档：README 含快速开始指南
- 许可证：Apache-2.0
- 已发布到 mooncakes.io（Magic486/moonindex）

---

**申请人**：Magic486
**申请日期**：2026 年 6 月
