
docker-compose是什么？

Elasticsearch:分布式数据库

Lucene：ES的底层，开源库。ES是 Lucene 的封装，提供了 REST API 的操作接口，开箱即用

Kibana ：ES数据可视化工具

节点：单个 Elastic 实例称为一个节点（node）。一组节点构成一个集群（cluster）。

索引：Elastic 会索引所有字段，经过处理后写入一个反向索引（Inverted Index）。查找数据的时候，直接查找该索引。

所以，Elastic 数据管理的顶层单位就叫做 Index（索引）。它是单个数据库的同义词。每个 Index （即数据库）的名字必须是小写。

Document：Index 里面单条的记录称为 Document（文档）。许多条 Document 构成了一个 Index。

Type：
Document 可以分组，比如weather这个 Index 里面，可以按城市分组（北京和上海），也可以按气候分组（晴天和雨天）。这种分组就叫做 Type，它是虚拟的逻辑分组，用来过滤 Document。

不同的 Type 应该有相似的结构（schema），举例来说，id字段不能在这个组是字符串，在另一个组是数值。这是与关系型数据库的表的一个区别。性质完全不同的数据（比如products和logs）应该存成两个 Index，而不是一个 Index 里面的两个 Type（虽然可以做到）。 
根据规划，Elastic 6.x 版只允许每个 Index 包含一个 Type，7.x 版将会彻底移除 Type。

