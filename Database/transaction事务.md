# GreenPlum 事务

## 缓冲区管理 (Buffer Pool)

Greenplum 使用了 PostgreSQL 的缓冲区管理机制，即 buffer pool。buffer pool 是一个内存区域，用于存储磁盘上的数据块。buffer pool 的大小可以配置，通常是数据库实例内存的一部分。其大小对数据库性能有很大影响：

- **Buffer pool 太小**：数据库将频繁地从磁盘读取数据块，降低性能。
- **Buffer pool 太大**：占用过多内存，导致操作系统频繁进行内存交换，降低性能。

Buffer pool 内部由多个 block 组成，每个 block 又分为很多 page。数据库以 page 为单位进行 I/O 操作。

## 事务的四个特性 (ACID)

1. **原子性 (Atomicity)**：
   - 一个事务中的所有操作要么全部完成，要么全部不完成。如果发生错误，事务会回滚到开始前的状态。
2. **一致性 (Consistency)**：
   - 事务操作前后，数据要满足完整性约束，保持一致性状态。
3. **隔离性 (Isolation)**：
   - 并发事务的操作彼此隔离，一个事务的执行不会被其他事务干扰。
4. **持久性 (Durability)**：
   - 事务完成后，对数据的修改是永久的，即使系统故障也不会丢失。

mysql InnoDB 引擎通过以下技术保证事务的 ACID 特性：

- **持久性**：通过 redo log 保证。
- **原子性**：通过 undo log 保证。
- **隔离性**：通过 MVCC 或锁机制保证。
- **一致性**：通过持久性、原子性和隔离性共同保证。

PostgreSQL：

- **持久性**：通过 WAL (Write-Ahead Logging) 保证。
- **原子性**：通过 MVCC 保证，数据修改创建新版本，旧版本保留。
- **隔离性**：通过 MVCC 和锁机制（行级锁）保证。
- **一致性**：通过完整性约束、触发器、规则以及持久性、原子性和隔离性共同保证。

**缓冲区管理方式**：Greenplum、PostgreSQL、MySQL、Oracle 都采用 buffer pool 方式进行缓冲区管理。

## 隐式事务

mysql的innodb和postgres对待每个单一的sql都是隐式事务, 也就是在每个sql前面默认加上`begin`,在末尾加上`commit`

## savepoint

It's possible to control the statements in a transaction in a more granular fashion through the use of `savepoints`. Savepoints allow you to selectively discard parts of the transaction, while committing the rest. After defining a savepoint with `SAVEPOINT`, you can if needed roll back to the savepoint with `ROLLBACK TO`. All the transaction's database changes between defining the savepoint and rolling back to it are discarded, but changes earlier than the savepoint are kept.

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Bob';
-- oops ... forget that and use Wally's account
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Wally';
COMMIT;
```

## Write-Ahead Logging (WAL) 策略

在数据库中，关于事务和 buffer pool，有四种写入策略：

1. **force/no-force**：
   - **force**：事务提交时，修改的页面必须强制写入磁盘。
   - **no-force**：事务提交时，修改的页面不一定要写入磁盘。

2. **steal/no-steal**：
   - **steal**：允许 buffer pool 里未提交事务所修改的脏页刷回到持久存储。
   - **no-steal**：不允许 buffer pool 里未提交事务所修改的脏页刷回到持久存储。

**force策略**对持久存储器进行频繁地随机写, 性能会下降.
**no-steal策略**, 如果一个事务修改了大部分的数据, 把buffer pool占满了, 其他事务就没办法申请到空间, 导致并发量不高.

所以通常数据库采用 No-force/steal 策略，以获得良好的性能。这种先将事务的数据写入日志文件，再写入磁盘的方式称为 Write-Ahead Logging (WAL) 策略。这里的WAL策略区分postgresql的WAL日志, 两者不是一个概念.

但是这会引发一个问题, 如何保证原子性和持久性呢? 因为no-force突然断电, 就会丢失数据, steal策略写入到磁盘中, 但是想回滚却断电, 就导致脏数据.

### 方法一：Redo/Undo 日志

引入日志：

- **No-force -> Redo log**：事务提交时，数据页不需要刷回持久存储。为保证持久性，先将 Redo Log 写入日志文件。Redo Log 记录修改数据对象的新值 (After Image, AFIM)。
- **Steal -> Undo log**：允许 buffer pool 未提交事务所修改的脏页刷回持久存储。为保证原子性，先将 Undo Log 写入日志文件。Undo Log 记录修改数据对象的旧值 (Before Image, BFIM)。

![缓冲区管理策略和事务恢复关系图](/Image/database/93.png)

### WAL 日志

1. 任何 page 在写入磁盘之前，必须先保证日志先写入磁盘：
   - Steal 策略，记录 undo log，保证原子性。
2. 在确保事务对数据修改的日志写入磁盘之后，才能提交事务：
   - No-force 策略，记录 redo log，保证持久性。

## MySQL vs PostgreSQL

- **MySQL**：采用 redo + undo。表中通常只有当前版本的数据行，历史版本通过 undo 日志记录。在读取旧版本时，利用 undo 日志恢复历史数据。
- **PostgreSQL**：只有 WAL。直接在表中存储多个物理版本的数据行，每个版本行包含创建和删除该版本的事务 ID。旧版本数据在不需要时被 VACUUM 清理。读取数据时，通过检查数据行的事务 ID 选择合适的版本。

## Greenplum 采用的 Buffer Pool 策略

Greenplum 采用 Steal + No-force + Redo Log，没有 undo log。这是因为 Greenplum 采用 heap 表，更新操作不是 in place，而是重新创建新的 tuple，通过事务可见性判断数据对某个事务是否可见。和porstgres差不多

但是greenPlum是分布式事务. 分布式事务是典型的嵌套式事务，一个事务由多个工作节点的子事务构成，要么全部提交要么全部回滚。因为可能会遇到部分集群提交成功部分集群失败, 所以Greenplum 采用两阶段提交协议：

![94](/Image/database/94.png)
![94](/Image/database/95.png)

第一次发送 prepare，只有当收到集群返回的 ack，才会发送 commit。如果有一个节点失败，就会回滚。
