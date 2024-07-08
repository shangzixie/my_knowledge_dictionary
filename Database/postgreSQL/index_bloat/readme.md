# overview

[toc]

## why index will bloat

When an UPDATE or DELETE statement is used in PostgreSQL, it does not physically remove that row from the disk. In an UPDATE case, it marks the effected rows as invisible and INSERTs the new version of those rows. While DELETE is little simple the effected rows are just marked as invisibles. These invisibles rows are also called dead rows or dead tuples.Over the time these dead tuples can accumulate to a huge number and in some worst case scenarios, it possible that this accumulation is even greater that the actual rows in the table becomes unusable.

## Based on check_postgres

One of the common needs for a REINDEX is when indexes become bloated due to either sparse deletions or use of VACUUM FULL (with pre 9.0 versions). An estimator for the amount of bloat in a table has been included in the [check_postgres](http://bucardo.org/wiki/Check_postgres) script, which you can call directly or incorporate into a larger monitoring system. Scripts based on this code and/or its concepts from other sources include:

* [bloat view (Dimitri Fontaine)](https://web.archive.org/web/20080603000756/http://pgsql.tapoueh.org/site/html/news/20080131.bloat.html) - extracted from check_postgres
* [Visualizing Postgres](https://www.pgcon.org/2009/schedule/events/153.en.html) - index_byte_sizes view (Michael Glaesemann, myYearbook)
* [OmniTI Tasty Treats for Postgre
* SQL](https://github.com/omniti-labs/) - shell and Perl pg_bloat_report scripts

## New query

A new query has been created to have a better bloat estimate for Btree indexes. Unlike the query from `check_postgres`, this one focus only on BTree index its disk layout.

See [articles](http://blog.ioguix.net/tag/bloat/) about it.

The monitoring script [check_pgactivity](https://github.com/OPMDG/check_pgactivity) is including a check based on this work.

## reference

[wiki](https://wiki.postgresql.org/wiki/Index_Maintenance#Index_Bloat)
