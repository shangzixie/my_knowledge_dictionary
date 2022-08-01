# TOAST

In order to keep physical data rows from exceeding the size of a data page (typically 8KB), the PostgreSQL use TOAST mechanism.
PostgreSQL does not support physical rows that cross block boundaries, so the page size is a hard upper limit on row size. To allow user tables to have rows wider than this, the TOAST mechanism breaks up wide field values into smaller pieces, which are stored "out of line" in a TOAST table associated with the user table.

Each table you create has its own associated (unique) TOAST table, which may or may not ever end up being used, depending on the size of rows you insert. All of this is transparent to the user, and enabled by default.

When a row that is to be stored is "too wide" (the threshold for that is 2KB by default), the TOAST mechanism first attempts to compress any wide field values. If that isn't enough to get the row under 2KB, it breaks up the wide field values into chunks that get stored in the associated TOAST table. Each original field value is replaced by a small pointer that shows where to find this "out of line" data in the TOAST table. TOAST will attempt to squeeze the user-table row down to 2KB in this way, but as long as it can get below 8KB, that's good enough and the row can be stored successfully.