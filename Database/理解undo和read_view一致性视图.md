# 理解undo log 和 read view一致性视图图

pg和mysql默认都是隐藏事务, 一条sql也会默认开启事务

## mySQL

首先了解一个概念`活跃事务`: 指未提交的事务

创建一个事务时候, 就会创建一个read view. 这个read view有一下几个字段:

![115](/Image/database/115.png)

* `m_ids`：指的是在创建 Read View 时，当前数据库中「活跃事务」的事务 id 列表.
* `min_trx_id`：指的是在创建 Read View 时，当前数据库中「活跃事务」中事务 id 最小的事务，也就是 m_ids 的最小值。
* `max_trx_id`：这个并不是 m_ids 的最大值，而是创建 Read View 时当前数据库中应该给下一个事务的 id 值，也就是全局系统事务中最大的事务 id 值 + 1；这里要注意是全局系统中的事务id，不是正在活跃的事务id列表中的事务id。 比如，现在有id为1，2，3这三个事务，之后id为3的事务提交了。那么一个新的读事务在生成ReadView时，`min_trx_id`的值就是1，`max_trx_id`的值就是4。
* `creator_trx_id`：指的是创建该 Read View 的事务的事务 id。

在innoDB中, 每行数据还有两个隐藏列, 假设把这两个隐藏列也画出来，该记录的整个示意图如下:

![115](/Image/database/116.png)

* `trx_id`，当一个事务对某条聚簇索引记录进行改动时，就会把该事务的事务 id 记录在 trx_id 隐藏列里；
* `roll_pointer`，每次对某条聚簇索引记录进行改动时，都会把旧版本的记录写入到 undo 日志中，然后这个隐藏列是个指针，指向每一个旧版本记录，于是就可以通过它找到修改前的记录。

假设之后有两个id分别为10，20的事务对上面id为1的记录进行UPDATE操作，流程如下:

![115](/Image/database/117.png)

每次对记录进行改动，都会记录一条undo日志，每条undo日志也都有一个roll_pointer属性.可以将这些undo日志都连起来，串成一个链表：就是版本链，越上面的记录越新. 绿色数据在undo log中, 蓝色数据在数据库中.

![115](/Image/database/118.png)

一个事务去访问一条数据记录的时候，除了自己的更新记录总是可见之外，还有这几种情况：

1. 如果该数据记录的`trx_id`值小于 Read View 中的 `min_trx_id` 值，表示这个版本的记录是在创建 Read View 前已经提交的事务生成的，所以该版本的记录对当前事务可见。
2. 如果该数据记录的`trx_id`值大于等于 Read View 中的 `max_trx_id` 值，表示这个版本的记录是在创建 Read View 后才启动的事务生成的，所以该版本的记录对当前事务不可见。
3. 如果该数据记录的`trx_id`值在 Read View 的 `min_trx_id` 和 `max_trx_id` 之间，需要判断`trx_id`是否在`m_ids`列表中：

   * 如果记录的 trx_id 在 m_ids 列表中，表示生成该版本记录的活跃事务依然活跃着（还没提交事务），所以该版本的记录对当前事务不可见。
   * 如果记录的 trx_id 不在 m_ids列表中，表示生成该版本记录的活跃事务已经被提交，所以该版本的记录对当前事务可见。

### 可重复读

可重复读隔离级别是启动事务时生成一个 Read View，然后整个事务期间都在用这个 Read View。所以具体工作情况流程就是上面所示

### 读已提交

读提交隔离级别是在每次读取数据时，都会生成一个新的 Read View。

流程如下:

![119](/Image/database/119.png)
![120](/Image/database/120.png)

### 总结

这就是undo log如何和mvcc一起工作的, 通过read view来保证事务的隔禽性.

## postgres

因为表是heap表, 每次`insert`操作不是插入到undo log里面, 而是插入到实际的表格里面.

## reference

[小林coding](https://xiaolincoding.com/mysql/transaction/mvcc.html#read-view-%E5%9C%A8-mvcc-%E9%87%8C%E5%A6%82%E4%BD%95%E5%B7%A5%E4%BD%9C%E7%9A%84)
[MySQL——MVCC实现原理之ReadView](https://juejin.cn/post/7154701807694905351)
