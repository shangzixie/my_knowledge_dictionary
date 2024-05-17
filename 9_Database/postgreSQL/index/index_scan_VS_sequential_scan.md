# index scan VS sequential scan

If the SELECT returns more than approximately 5-10% of all rows in the table, a sequential scan is much faster than an index scan.

This is because an index scan requires several IO operations for each row (look up the row in the index, then retrieve the row from the heap). Whereas a sequential scan only requires a single IO for each row - or even less because a block (page) on the disk contains more than one row, so more than one row can be fetched with a single IO operation.

Also, a sequential scan can request several pages from the heap at a time, and ask the kernel to be fetching the next chunk while it works on the current one- an index scan fetches one page at once. (A bitmap scan does a compromise between the two, you usually see that appearing in a plan for queries that aren't selective enough for an index scan, but still not so unselective as to merit a full table scan)

Btw: this is true for other DBMS as well - some optimizations as "index only scans" taken aside (but for a SELECT * it's highly unlikely such a DBMS would go for an "index only scan")

## how databasae  knows how many rows the query will return without doing it first?

[the query planner](https://www.postgresql.org/docs/current/planner-stats.html)
