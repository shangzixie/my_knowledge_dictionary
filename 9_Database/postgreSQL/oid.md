# OID

OIDs basically give you a built-in id for every row, contained in a system column (as opposed to a user-space column). That's handy for tables where you don't have a primary key, have duplicate rows, etc. For example, if you have a table with two identical rows, and you want to delete the oldest of the two, you could do that using the oid column.

OIDs are implemented using 4-byte unsigned integers. They are not unique-OID counter will wrap around at 2³²-1. OID are also used to identify data types (see /usr/include/postgresql/server/catalog/pg_type_d.h).

## reference

[stack overflow](https://stackoverflow.com/questions/5625585/sql-postgres-oids-what-are-they-and-why-are-they-useful)