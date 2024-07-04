# undo log、redo log、binlog 有什么用？

* undo log（回滚日志）：是 Innodb 存储引擎层生成的日志，实现了事务中的原子性，主要用于事务回滚和 MVCC。
* redo log（重做日志）：是 Innodb 存储引擎层生成的日志，实现了事务中的持久性，主要用于掉电等故障恢复；
* binlog （归档日志）：是 Server 层生成的日志, 即使用MyISAM引擎也有，主要用于数据备份和主从复制；

## undo log

