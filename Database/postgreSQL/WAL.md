# Write-Ahead Logging (WAL)

Write-Ahead Logging (WAL) is a standard method for ensuring data integrity. Briefly, WAL's central concept is that changes to data files (where tables and indexes reside) must be written only after those changes have been logged, that is, after WAL records describing the changes have been flushed to permanent storage.
更改数据之前， 必须保证先将操作进行记录log，然后再进行数据的更改。如果在更改数据的时候出现了crash，可以通过log进行恢复。

## principle

First, need to know the [buffer cache](./buffer_cache.md)

先写到日志， 再合适的时机再写到数据文件中。There is a `WALWriter` do the write job. so, when the database write the data:

1. when after commit
2. WAL buffer is full
3. write periodically

## wal replica


## reference

[postgres documents](https://www.postgresql.org/docs/current/wal-intro.html)