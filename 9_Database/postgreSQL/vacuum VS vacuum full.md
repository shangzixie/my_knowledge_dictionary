# vacuum VS vacuum full

"regular vacuum marks empty space for re-use, and reclaims the empty space at the end of a relation. So if the empty space is in the middle etc it can't be reclaimed just reused.
vacuum full compacts a relation reclaiming all the empty space. It requires an exclusive lock and is bad for production systems in general because of this.
So the purpose of REGULAR vacuum is not to reclaim space from the tables but to make it available for reuse later. The purpose of vacuum FULL is to reclaim all wasted space at the expense of an exclusive lock and db performance while it's happening.
vacuum full will actually create new files for the table (the existing files would have shrunk to 0 size). Thus OS can reclaim the space.

## reference

[stackOverFlow](https://dba.stackexchange.com/questions/56374/vacuum-freeze-vs-vacuum-full)