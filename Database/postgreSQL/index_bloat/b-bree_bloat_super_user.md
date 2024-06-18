# calculate b-tree bloat by super user

## idx_data

reltuples: Number of live rows in the table

relpages: Number of pages in the table

indrelid, tbloid: The OID of the pg_class entry for the table this index is for

indexrelid, idxoid: The OID of the pg_class entry for this index

indnatts: The total number of columns in the index

indkey: This is an array of indnatts values that indicate which table columns this index indexes. For example a value of 1 3 would mean that the first and the third table columns make up the index entries.

```sql
create view idx_data as
    SELECT
        ci.relname AS idxname,
        ci.reltuples,
        ci.relpages,
        i.indrelid AS tbloid,
        i.indexrelid AS idxoid,
        coalesce(substring(array_to_string(ci.reloptions, ' ') from 'fillfactor=([0-9]+)')::smallint, 90) AS fillfactor,
        i.indnatts,
        string_to_array(textin(int2vectorout(i.indkey)),' ')::int[] AS indkey
    FROM pg_index i
    JOIN pg_class ci ON ci.oid=i.indexrelid
    WHERE ci.relam=(SELECT oid FROM pg_am WHERE amname = 'btree')
    AND ci.relpages > 0;
```

## idx_data_cross

```sql
CREATE VIEW idx_data_cross as
SELECT
    idxname,
    reltuples,
    relpages,
    tbloid,
    idxoid,
    fillfactor,
    indkey,
    generate_series(1,indnatts) AS i
FROM idx_data;
```

## i

```sql
CREATE view i as
SELECT
    idxname,
    reltuples,
    relpages,
    tbloid,
    idxoid,
    fillfactor,
    CASE WHEN indkey[i]=0 THEN idxoid ELSE tbloid END AS att_rel,
    CASE WHEN indkey[i]=0 THEN i ELSE indkey[i] END AS att_pos
FROM idx_data_cross;
```

## rows_data_stats

maxalign: MAXALIGN, 4 on 32bits, 8 on 64bits (and mingw32 ?)

pagehdr: per page header, fixed size: 20 for 7.X, 24 for others

pageopqdata: the size of special zone in page

nulldatawidth: all non-null columns length

nulldatawidth: index tuple header length (IndexTupleData size + IndexAttributeBitMapData size ( max num filed per index + 8 - 1 /8))

bs: one page's size

```sql
CREATE view rows_data_stats AS
SELECT
    n.nspname,
    ct.relname AS tblname,
    i.idxname,
    i.reltuples,
    i.relpages,
    i.idxoid,
    i.fillfactor,
    current_setting('block_size')::numeric AS bs,
    CASE
        WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
        ELSE 4
    END AS maxalign,
    24 AS pagehdr,
    16 AS pageopqdata,
    CASE
        WHEN max(coalesce(s.stanullfrac,0)) = 0
        THEN 6
        ELSE 6 + (( 32 + 8 - 1 ) / 8)
    END AS index_tuple_hdr_bm,
    sum( (1-coalesce(s.stanullfrac, 0)) * coalesce(s.stawidth, 1024)) AS nulldatawidth,
    max( CASE WHEN a.atttypid = 'pg_catalog.name'::regtype THEN 1 ELSE 0 END ) > 0 AS is_na
FROM i
JOIN pg_attribute a ON a.attrelid = i.att_rel AND a.attnum = i.att_pos
JOIN pg_statistic s ON s.starelid = i.att_rel AND s.staattnum = i.att_pos
JOIN pg_class ct ON ct.oid = i.tbloid
JOIN pg_namespace n ON ct.relnamespace = n.oid
GROUP BY 1,2,3,4,5,6,7,8,9,10;
```

## rows_hdr_pdg_stats

nulldatahdrwidth: one tuple size (has considered null value and MAXALIGN)

```sql
CREATE view rows_hdr_pdg_stats AS
SELECT
    maxalign,
    bs,
    nspname,
    tblname,
    idxname,
    reltuples,
    relpages,
    idxoid,
    fillfactor,
    ( index_tuple_hdr_bm +
        maxalign - CASE -- Add padding to the index tuple header to align on MAXALIGN
            WHEN index_tuple_hdr_bm%maxalign = 0 THEN maxalign
            ELSE index_tuple_hdr_bm%maxalign
        END
        + nulldatawidth + maxalign - CASE -- Add padding to the data to align on MAXALIGN
            WHEN nulldatawidth = 0 THEN 0
            WHEN nulldatawidth::integer%maxalign = 0 THEN maxalign
            ELSE nulldatawidth::integer%maxalign
        END
    )::numeric AS nulldatahdrwidth,
    pagehdr,
    pageopqdata,
    is_na
from rows_data_stats;
```

## relation_stats

4 is the item pointer size
`how many rows could insert one page = (all items pointer size + all tuples size) in a page / (one item pointer size + one data row size) = bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)`

`how many pages used if all size is fulfilled = reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)`

reltuples: the number of live tuples in a page

est_pages：the number of used pages (without bloat), not consider fillfactor

est_pages_ff：the number of used pages, consider fillfactor

```sql
CREATE view relation_stats AS
SELECT
    coalesce(1 + ceil(reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float)), 0 -- ItemIdData size + computed avg size of a tuple (nulldatahdrwidth)
    ) AS est_pages,
    coalesce(1 + ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0
    ) AS est_pages_ff,
    bs,
    nspname,
    tblname,
    idxname,
    relpages,
    fillfactor,
    is_na

FROM rows_hdr_pdg_stats;
```

## output

```sql
SELECT
    current_database(),
    nspname AS schemaname,
    tblname,
    idxname,
    bs*(relpages)::bigint AS real_size,
    bs*(relpages-est_pages)::bigint AS extra_size,
    100 * (relpages-est_pages)::float / relpages AS extra_pct,
    fillfactor,
    CASE
        WHEN relpages > est_pages_ff
        THEN bs*(relpages-est_pages_ff)
        ELSE 0
    END AS bloat_size,
    100 * (relpages-est_pages_ff)::float / relpages AS bloat_pct,
    is_na
FROM relation_stats
ORDER BY nspname, tblname, idxname;
```
