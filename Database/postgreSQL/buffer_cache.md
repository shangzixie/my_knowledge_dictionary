# buffer cache

The buffer cache is a portion of memory allocated to store copies of database pages (blocks) that are read from or written to the disk. When a database page is needed for a query or an update, PostgreSQL first checks if the page is already in the buffer cache. If it is, the operation can proceed without accessing the disk, resulting in faster performance.

也就是说， `upadte`或者`delete`的数据，首先会在buffer cache中进行操作，然后再合适时机写入到磁盘中。
![1](/Image/database/91.png)

so, when write into disk? read [WAL](./WAL.md)