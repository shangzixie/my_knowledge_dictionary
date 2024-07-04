# undo log、redo log、binlog 有什么用？

* undo log（回滚日志）：是 Innodb 存储引擎层生成的日志，实现了事务中的原子性，主要用于事务回滚和 MVCC。
* redo log（重做日志）：是 Innodb 存储引擎层生成的日志，实现了事务中的持久性，主要用于掉电等故障恢复；
* binlog （归档日志）：是 Server 层生成的日志, 即使用MyISAM引擎也有，主要用于数据备份和主从复制；

## buffer poll

MySQL 的数据存储在磁盘上，但更新记录时会先读入内存并修改。修改后的记录不会立即写回磁盘，而是缓存起来，以提高性能。为了实现这一点，InnoDB 存储引擎设计了一个缓冲池（Buffer Pool）来提升数据库的读写效率。

![121](/Image/database/121.png)

有了 Buffer Pool 后：

* 读取数据：若数据在 Buffer Pool 中，直接读取；否则从磁盘读取。
* 修改数据：若数据在 Buffer Pool 中，直接修改并标记为脏页，不立即写入磁盘，后续由后台线程在合适时机写回磁盘。

buffer poll里面的数据类型:

![121](/Image/database/122.png)

开启事务后，InnoDB 层更新记录前，首先要记录相应的 undo log，如果是更新操作，需要把被更新的列的旧值记下来，也就是要生成一条 undo log，undo log 会写入 Buffer Pool 中的 `Undo 页面`

## undo log

* 在插入一条记录时，要把这条记录的主键值记下来，这样之后回滚时只需要把这个主键值对应的记录删掉就好了；
* 在删除一条记录时，要把这条记录中的内容都记下来，这样之后回滚时再把由这些内容组成的记录插入到表中就好了；
* 在更新一条记录时，要把被更新的列的旧值记下来，这样之后回滚时再把这些列更新为旧值就好了。

另外，undo log 还有一个作用，通过 ReadView + undo log 实现 MVCC（多版本并发控制）。详细看[理解undo和read view一致性视图图](/Database/%E7%90%86%E8%A7%A3undo%E5%92%8Cread_view%E4%B8%80%E8%87%B4%E6%80%A7%E8%A7%86%E5%9B%BE.md)

## redo log

Buffer Pool 提高了读写效率，但内存不可靠，断电会导致未落盘的脏页数据丢失。为防止数据丢失，InnoDB 在更新记录时，先更新内存buffer poll并标记脏页，同时记录 redo log，这样更新就完成了。随后，后台线程在适当时机将脏页刷新到磁盘。这就是 WAL（Write-Ahead Logging）技术，即写操作先写日志，再在合适时间写入磁盘。

所以有了 redo log，再通过 WAL 技术，InnoDB 就可以保证即使数据库发生异常重启，之前已提交的记录都不会丢失，这个能力称为 crash-safe（崩溃恢复）。可以看出来， redo log 保证了事务四大特性中的持久性。

redo log 是记录数据页修改的物理日志。每个事务执行时生成一条或多条日志，记录对具体数据页的更新。事务提交时，只需将 redo log 持久化到磁盘，无需等待 Buffer Pool 中的脏页数据写入磁盘。系统崩溃后，重启 MySQL 时根据 redo log 恢复数据到最新状态。

### redo log 的写入

所以redo log是对buffer pool中的数据进行持久化的一种机制。那为什么不直接进行持久化, 还要写入redo log呢？
写入 redo log 的方式使用了追加操作， 所以磁盘操作是`顺序写`，而写入数据需要先找到写入位置，然后才写到磁盘，所以磁盘操作是`随机写`

磁盘的「顺序写 」比「随机写」 高效的多，因此 redo log 写入磁盘的开销更小。

![121](/Image/database/123.png)

## redo undo区别

redo log 记录了此次事务「完成后」的数据状态，记录的是更新之后的值；

undo log 记录了此次事务「开始前」的数据状态，记录的是更新之前的值；

## binlog

MySQL 在完成一条更新操作后，Server 层还会生成一条 binlog，等之后事务提交的时候，会将该事物执行过程中产生的所有 binlog 统一写 入 binlog 文件。

binlog 文件是记录了所有数据库表结构变更和表数据修改的日志，不会记录查询类的操作，比如 SELECT 和 SHOW 操作。

为什么有了 binlog， 还要有 redo log？最开始 MySQL 里并没有 InnoDB 引擎，MySQL 自带的引擎是 MyISAM，但是 MyISAM 没有 crash-safe 的能力，binlog 日志只能用于归档。

![121](/Image/database/124.png)

### 如果不小心整个数据库的数据被删除了，能使用 redo log 文件恢复数据吗？

不可以使用 redo log 文件恢复，只能使用 binlog 文件恢复。

因为 redo log 文件是循环写，是会边写边擦除日志的，只记录未被刷入磁盘的数据的物理日志，已经刷入磁盘的数据都会从 redo log 文件里擦除。

## reference

[小林](https://xiaolincoding.com/mysql/log/how_update.html#%E4%B8%BA%E4%BB%80%E4%B9%88%E9%9C%80%E8%A6%81-undo-log)