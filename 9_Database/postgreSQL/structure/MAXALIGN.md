# MAXALIGN

![40](../../../Image/database/40.png)

The `HeapTupleHeader` (per row) is 23 bytes long, actual `column data` always starts at a multiple of `MAXALIGN` (typically 8 bytes). That leaves `1` byte of padding that can be utilized by the `NULL bitmap`. In effect NULL storage is absolutely free for tables up to 8 columns.

After that, another MAXALIGN (typically 8) bytes are allocated for the next MAXALIGN * 8(typically 64) columns. Etc. Always for the total number of user columns (all or nothing). But only if there is at least one actual NULL value in the row.
