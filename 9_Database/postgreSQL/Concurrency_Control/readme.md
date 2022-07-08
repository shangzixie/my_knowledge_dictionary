# Concurrency Control

PostgreSQL and some RDBMSs use a variation of MVCC called Snapshot Isolation (SI).

To implement SI, some RDBMSs, e.g., Oracle, use rollback segments. When writing a new data item, the old version of the item is written to the rollback segment, and subsequently the new item is overwritten to the data area. PostgreSQL uses a simpler method. A new data item is inserted directly into the relevant table page. When reading items, PostgreSQL selects the appropriate version of an item in response to an individual transaction by applying visibility check rules.