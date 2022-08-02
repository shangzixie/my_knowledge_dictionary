# get index bloat

## explain the [SQL](./check_index_bloat.sql)

### the first step: 获取到所有的btree类型的index的信息 - idx_data

解释：

1. the default fillfactor is 90%
2. indexrelid 是index oid 对应到pg_class中index的oid
3. indrelid 是 index 对应的表的oid
4. indkey: is a array that indicate which table columns this index indexes. For example a value of `{1 3}` would mean that the first and the third table columns make up the index entries. Key columns come before non-key (included) columns

```sql
SELECT
    ci.relname AS idxname,
    ci.reltuples,
    ci.relpages,
    i.indrelid AS tbloid,
    i.indexrelid AS idxoid,
    coalesce(substring(array_to_string(ci.reloptions, ' ') from 'fillfactor=([0-9]+)')::smallint, 90) AS fillfactor,
    i.indnatts,
    pg_catalog.string_to_array(pg_catalog.textin(pg_catalog.int2vectorout(i.indkey)),' ')::int[] AS indkey
FROM pg_catalog.pg_index i
JOIN pg_catalog.pg_class ci ON ci.oid = i.indexrelid
    WHERE ci.relam =
        ( SELECT oid FROM pg_am WHERE amname = 'btree')
        AND ci.relpages > 0;


---创建视图

create view idx_data as
  SELECT ci.relname AS idxname, ci.reltuples, ci.relpages, i.indrelid AS tbloid,
          i.indexrelid AS idxoid,
          coalesce(substring(
              array_to_string(ci.reloptions, ' ')
              from 'fillfactor=([0-9]+)')::smallint, 90) AS fillfactor,
          i.indnatts,
          pg_catalog.string_to_array(pg_catalog.textin(
              pg_catalog.int2vectorout(i.indkey)),' ')::int[] AS indkey
      FROM pg_catalog.pg_index i
      JOIN pg_catalog.pg_class ci ON ci.oid = i.indexrelid
      WHERE ci.relam=(SELECT oid FROM pg_am WHERE amname = 'btree')
      AND ci.relpages > 0;

select * from idx_data order by tbloid desc limit 5;


       idxname        | reltuples | relpages | tbloid | idxoid | fillfactor | indnatts | indkey
----------------------+-----------+----------+--------+--------+------------+----------+--------
 idx_t1_2             |     1e+06 |     2745 |  24679 |  24683 |         90 |        1 | {1}
 idx_t1               |     1e+06 |     2745 |  24679 |  24682 |         90 |        1 | {1}
 idx_t                |     1e+06 |     3078 |  24675 |  24678 |         90 |        1 | {1}
 pg_toast_12633_index |         0 |        1 |  12636 |  12637 |         90 |        2 | {1,2}
 pg_toast_12628_index |         0 |        1 |  12631 |  12632 |         90 |        2 | {1,2}
(5 rows)
```

### the second step - ic

split index table

```sql
SELECT idxname, reltuples, relpages, tbloid, idxoid, fillfactor, indkey,
    pg_catalog.generate_series(1, indnatts) AS attpos
FROM idx_data
AS ic
```

1. `generate_series`:

```sql
SELECT * FROM generate_series(2,4);
 generate_series
-----------------
               2
               3
               4
(3 rows)

SELECT * FROM generate_series(5,1,-2);
 generate_series
-----------------
               5
               3
               1
(3 rows)
```

2. indnatts/attpos:

`attpos`: The total number of columns in the index (duplicates pg_class.relnatts); this number includes both key and included attributes

一个index中 attpos 如果有几个index列 就会分裂成几行 attpos 标识了序号
如下所示 为表中的每一行都分裂成了4行

```sql
postgres=# select * from zxj;
 tc1 | tc2
-----+-----
   1 |   1
   2 |   2
(2 rows)

postgres=# select *,generate_series(1,4) from zxj;
 tc1 | tc2 | generate_series
-----+-----+-----------------
   1 |   1 |               1
   1 |   1 |               2
   1 |   1 |               3
   1 |   1 |               4
   2 |   2 |               1
   2 |   2 |               2
   2 |   2 |               3
   2 |   2 |               4
(8 rows)
```

``` sql
SELECT idxname, reltuples, relpages, tbloid, idxoid, fillfactor, indkey,
  pg_catalog.generate_series(1,indnatts) AS attpos
FROM idx_data;
```

--建立视图

```sql
create view ic as
    SELECT
        idxname,
        reltuples,
        relpages,
        tbloid,
        idxoid,
        fillfactor,
        indkey,
        pg_catalog.generate_series(1,indnatts) AS attpos
    FROM idx_data;

```

```sql
select * from ic order by tbloid desc limit 10;

       idxname        | reltuples | relpages | tbloid | idxoid | fillfactor | indkey | attpos
----------------------+-----------+----------+--------+--------+------------+--------+--------
 ttt_idx              |         0 |        1 |  24703 |  24706 |         90 | {2,4}  |      1  以第二列和第四列建立索引， 这个第一个列
 ttt_idx              |         0 |        1 |  24703 |  24706 |         90 | {2,4}  |      2  以第二列和第四列建立索引，这个的第二个列
 idx_t1               |     1e+06 |     2745 |  24679 |  24682 |         90 | {1}    |      1
 idx_t1_2             |     1e+06 |     2745 |  24679 |  24683 |         90 | {1}    |      1
 idx_t                |     1e+06 |     3078 |  24675 |  24678 |         90 | {1}    |      1
 pg_toast_12633_index |         0 |        1 |  12636 |  12637 |         90 | {1,2}  |      1
 pg_toast_12633_index |         0 |        1 |  12636 |  12637 |         90 | {1,2}  |      2
 pg_toast_12628_index |         0 |        1 |  12631 |  12632 |         90 | {1,2}  |      1
 pg_toast_12628_index |         0 |        1 |  12631 |  12632 |         90 | {1,2}  |      2
 pg_toast_12623_index |         0 |        1 |  12626 |  12627 |         90 | {1,2}  |      1
```

### 步骤3 - i

解释

--与pg_attribute联查 获取到列信息

```sql
SELECT
    ct.relname AS tblname,
    ct.relnamespace,
    ic.idxname,
    ic.attpos,
    ic.indkey,
    ic.indkey[ic.attpos],
    ic.reltuples,
    ic.relpages,
    ic.tbloid,
    ic.idxoid,
    ic.fillfactor,
    coalesce(a1.attnum, a2.attnum) AS attnum,
    coalesce(a1.attname, a2.attname) AS attname, coalesce(a1.atttypid, a2.atttypid) AS atttypid,
    CASE WHEN a1.attnum IS NULL THEN ic.idxname
    ELSE ct.relname
    END AS attrelname
FROM  ic
JOIN pg_catalog.pg_class ct ON ct.oid = ic.tbloid
LEFT JOIN pg_catalog.pg_attribute a1
    ON     --表信息
        ic.indkey[ic.attpos] <> 0               --某列信息
        AND a1.attrelid = ic.tbloid
        AND a1.attnum = ic.indkey[ic.attpos]  --表的列
LEFT JOIN pg_catalog.pg_attribute a2
    ON
        ic.indkey[ic.attpos] = 0
        AND a2.attrelid = ic.idxoid           --索引列
        AND a2.attnum = ic.attpos;
```

 --创建视图

```sql
create view i as
SELECT
    ct.relname AS tblname,
    ct.relnamespace,
    ic.idxname,
    ic.attpos,
    ic.indkey,
    ic.indkey[ic.attpos] as indkeynum,
    ic.reltuples,
    ic.relpages,
    ic.tbloid,
    ic.idxoid,
    ic.fillfactor,
    coalesce(a1.attnum, a2.attnum) AS attnum, coalesce(a1.attname, a2.attname) AS attname, coalesce(a1.atttypid, a2.atttypid) AS atttypid,
    CASE WHEN a1.attnum IS NULL
    THEN ic.idxname
    ELSE ct.relname
    END AS attrelname
FROM  ic
JOIN pg_catalog.pg_class ct ON ct.oid = ic.tbloid
LEFT JOIN pg_catalog.pg_attribute a1 ON
    ic.indkey[ic.attpos] <> 0 AND a1.attrelid = ic.tbloid AND a1.attnum = ic.indkey[ic.attpos]
LEFT JOIN pg_catalog.pg_attribute a2 ON ic.indkey[ic.attpos] = 0 AND a2.attrelid = ic.idxoid AND a2.attnum = ic.attpos;
```

```sql
   select * from i order by tbloid desc limit 10;
         tblname          | relnamespace |                        idxname                        | attpos |  indkey   | indkey | reltuples | relpages |
 tbloid | idxoid | fillfactor | attnum |     attname     | atttypid |        attrelname
--------------------------+--------------+-------------------------------------------------------+--------+-----------+--------+-----------+----------+
--------+--------+------------+--------+-----------------+----------+--------------------------
 ttt                      |         2200 | ttt_idx                                               |      1 | {2,4}     |      2 |         0 |        1 |
  24703 |  24706 |         90 |      2 | tc2             |       23 | ttt
 ttt                      |         2200 | ttt_idx                                               |      2 | {2,4}     |      4 |         0 |        1 |
  24703 |  24706 |         90 |      4 | tc4             |       23 | ttt
 t1                       |         2200 | idx_t1                                                |      1 | {1}       |      1 |     1e+06 |     2745 |
  24679 |  24682 |         90 |      1 | id              |       23 | t1
 t1                       |         2200 | idx_t1_2                                              |      1 | {1}       |      1 |     1e+06 |     2745 |
  24679 |  24683 |         90 |      1 | id              |       23 | t1
 t                        |         2200 | idx_t                                                 |      1 | {1}       |      1 |     1e+06 |     3078 |
  24675 |  24678 |         90 |      1 | id              |       23 | t
```

### 步骤4------------------------------------------------------row_data_stats


解释
--与 pg_stats 联查，获取了indextuple的头信息长度 index_tuple_hdr_bm
  nulldatawidth 平均一个indextuple占用的size大小 考虑到了null值率
  is_na:这列是否是name类型

```sql
SELECT
    n.nspname,
    i.tblname,
    i.idxname,
    i.reltuples,å
    i.relpages,
    i.idxoid,
    i.fillfactor,
    current_setting('block_size')::numeric AS bs,
    CASE -- MAXALIGN: 4 on 32bits, 8 on 64bits (and mingw32 ?)
        WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
        ELSE 4
        END AS maxalign,
        /* per page header, fixed size: 20 for 7.X, 24 for others */
        24 AS pagehdr,
        /* per page btree opaque data */
        16 AS pageopqdata,
        /* per tuple header: add IndexAttributeBitMapData if some cols are null-able */
        CASE WHEN max(coalesce(s.null_frac,0)) = 0
            THEN 2 -- IndexTupleData size
            ELSE 2 + (( 32 + 8 - 1 ) / 8) -- IndexTupleData size + IndexAttributeBitMapData size ( max num filed per index + 8 - 1 /8)
            END AS index_tuple_hdr_bm,
            /* data len: we remove null values save space using it fractionnal part from stats */
            sum( (1-coalesce(s.null_frac, 0)) * coalesce(s.avg_width, 1024)) AS nulldatawidth,
            max( CASE WHEN i.atttypid = 'pg_catalog.name'::regtype THEN 1 ELSE 0 END ) > 0 AS is_na
FROM i
    JOIN pg_catalog.pg_namespace n ON n.oid = i.relnamespace
    JOIN pg_catalog.pg_stats s ON s.schemaname = n.nspname
                                AND s.tablename = i.attrelname
                                AND s.attname = i.attname
GROUP BY 1,2,3,4,5,6,7,8,9,10,11;
```

```sql
--创建视图
create view rows_data_stats as
SELECT n.nspname, i.tblname, i.idxname, i.reltuples, i.relpages,
              i.idxoid, i.fillfactor, current_setting('block_size')::numeric AS bs,
              CASE -- MAXALIGN: 4 on 32bits, 8 on 64bits (and mingw32 ?)
                WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
                ELSE 4
                END AS maxalign,
              /* per page header, fixed size: 20 for 7.X, 24 for others */
              24 AS pagehdr,
              /* per page btree opaque data */
              16 AS pageopqdata,
              /* per tuple header: add IndexAttributeBitMapData if some cols are null-able */
              CASE WHEN max(coalesce(s.null_frac,0)) = 0
                THEN 2 -- IndexTupleData size
                ELSE 2 + (( 32 + 8 - 1 ) / 8) -- IndexTupleData size + IndexAttributeBitMapData size ( max num filed per index + 8 - 1 /8)
              END AS index_tuple_hdr_bm,
              /* data len: we remove null values save space using it fractionnal part from stats */
              sum( (1-coalesce(s.null_frac, 0)) * coalesce(s.avg_width, 1024)) AS nulldatawidth,
              max( CASE WHEN i.atttypid = 'pg_catalog.name'::regtype THEN 1 ELSE 0 END ) > 0 AS is_na
          FROM i
            JOIN pg_catalog.pg_namespace n ON n.oid = i.relnamespace      --找到namespace
            JOIN pg_catalog.pg_stats s ON s.schemaname = n.nspname
                                      AND s.tablename = i.attrelname
                                      AND s.attname = i.attname
            GROUP BY 1,2,3,4,5,6,7,8,9,10,11;
```

```sql
ostgres=# select * from rows_data_stats order by idxoid desc limit 10;
  nspname   |     tblname      |            idxname            | reltuples | relpages | idxoid | fillfactor |  bs  | maxalign | pagehdr | pageopqdata |
 index_tuple_hdr_bm | nulldatawidth | is_na
------------+------------------+-------------------------------+-----------+----------+--------+------------+------+----------+---------+-------------+
--------------------+---------------+-------
 public     | t1               | idx_t1_2                      |     1e+06 |     2745 |  24683 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 public     | t1               | idx_t1                        |     1e+06 |     2745 |  24682 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 public     | t                | idx_t                         |     1e+06 |     3078 |  24678 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 pg_catalog | pg_ts_template   | pg_ts_template_oid_index      |         5 |        2 |   3767 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 pg_catalog | pg_ts_template   | pg_ts_template_tmplname_index |         5 |        2 |   3766 |         90 | 8192 |        8 |      24 |          16 |
                  2 |            68 | t
 pg_catalog | pg_ts_config     | pg_ts_config_oid_index        |        29 |        2 |   3712 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 pg_catalog | pg_ts_config_map | pg_ts_config_map_index        |       551 |        4 |   3609 |         90 | 8192 |        8 |      24 |          16 |
                  2 |            12 | f
 pg_catalog | pg_ts_config     | pg_ts_config_cfgname_index    |        29 |        2 |   3608 |         90 | 8192 |        8 |      24 |          16 |
                  2 |            68 | t
 pg_catalog | pg_ts_parser     | pg_ts_parser_oid_index        |         1 |        2 |   3607 |         90 | 8192 |        8 |      24 |          16 |
                  2 |             4 | f
 pg_catalog | pg_ts_parser     | pg_ts_parser_prsname_index    |         1 |        2 |   3606 |         90 | 8192 |        8 |      24 |          16 |
                  2 |            68 | t
(10 rows)


---https://blog.csdn.net/luojinbai/article/details/44957359
pg_stats描述
```

### 步骤5------------------------------------------------------rows_hdr_pdg_stats

解释
index_tuple_hdr_bm--一个index tuple占用的空间 已经考虑到了对其 tuple头等的长度

```sql
SELECT maxalign, bs, nspname, tblname, idxname, reltuples, relpages, idxoid, fillfactor,
( index_tuple_hdr_bm + maxalign -
    CASE -- Add padding to the index tuple header to align on MAXALIGN
        WHEN index_tuple_hdr_bm%maxalign = 0 THEN maxalign
        ELSE index_tuple_hdr_bm%maxalign
    END
    + nulldatawidth + maxalign - CASE -- Add padding to the data to align on MAXALIGN
        WHEN nulldatawidth = 0 THEN 0
        WHEN nulldatawidth::integer%maxalign = 0 THEN maxalign
        ELSE nulldatawidth::integer%maxalign
    END
)::numeric AS nulldatahdrwidth, pagehdr, pageopqdata, is_na -- , index_tuple_hdr_bm, nulldatawidth -- (DEBUG INFO)
FROM  rows_data_stats;
```

```sql
--创建视图
create view rows_hdr_pdg_stats as
SELECT maxalign, bs, nspname, tblname, idxname, reltuples, relpages, idxoid, fillfactor,
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
            )::numeric AS nulldatahdrwidth, pagehdr, pageopqdata, is_na
            -- , index_tuple_hdr_bm, nulldatawidth -- (DEBUG INFO)
      FROM  rows_data_stats;



postgres=# select * from rows_hdr_pdg_stats order by idxoid desc limit 10;

 maxalign |  bs  |  nspname   |     tblname      |            idxname            | reltuples | r
elpages | idxoid | fillfactor | nulldatahdrwidth | pagehdr | pageopqdata | is_na 
----------+------+------------+------------------+-------------------------------+-----------+--
--------+--------+------------+------------------+---------+-------------+-------
        8 | 8192 | public     | t2               | idx_t2                        |       200 |  
      2 |  24723 |         90 |               16 |      24 |          16 | f
        8 | 8192 | public     | t1               | idx_t1_2                      |     1e+06 |  
   2745 |  24683 |         90 |               16 |      24 |          16 | f
        8 | 8192 | public     | t1               | idx_t1                        |     1e+06 |  
   2745 |  24682 |         90 |               16 |      24 |          16 | f
        8 | 8192 | public     | t                | idx_t                         |     1e+06 |  
   3078 |  24678 |         90 |               16 |      24 |          16 | f
```



步骤6------------------------------------------------------relation_stats    

解释
先求出一个页面中可以容纳的indextuple的个数：页面可用空间（总空间-头信息）/（indextuple大小+itemiddata）

就是需要的页面数=总的tuple数/一个页面容纳的tuple数目 


est_pages：未考虑fillfactor时需要的页面数字
est_pages_ff：考虑了fillfactor后需要的页面数



  SELECT coalesce(1 +
         ceil(reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float)), 0 -- ItemIdData size + computed avg size of a tuple (nulldatahdrwidth)
      ) AS est_pages,
      coalesce(1 +
         ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0
      ) AS est_pages_ff,
      bs, nspname, tblname, idxname, relpages, fillfactor, is_na
      -- , pgstatindex(idxoid) AS pst, index_tuple_hdr_bm, maxalign, pagehdr, nulldatawidth, nulldatahdrwidth, reltuples -- (DEBUG INFO)
  FROM  rows_hdr_pdg_stats;

--创建视图
create view relation_stats as
 SELECT coalesce(1 +
         ceil(reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float)), 0 -- ItemIdData size + computed avg size of a tuple (nulldatahdrwidth)
      ) AS est_pages,
      coalesce(1 +
         ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0
      ) AS est_pages_ff,
      bs, nspname, tblname, idxname, relpages, fillfactor, is_na
      -- , pgstatindex(idxoid) AS pst, index_tuple_hdr_bm, maxalign, pagehdr, nulldatawidth, nulldatahdrwidth, reltuples -- (DEBUG INFO)
  FROM  rows_hdr_pdg_stats;

postgres=# select * from relation_stats where idxname like 'idx_%';
 est_pages | est_pages_ff |  bs  | nspname | tblname | idxname  | relpages | fillfactor | is_na 
-----------+--------------+------+---------+---------+----------+----------+------------+-------
      2459 |         2734 | 8192 | public  | t       | idx_t    |     3078 |         90 | f
      2459 |         2734 | 8192 | public  | t1      | idx_t1   |     2745 |         90 | f
      2459 |         2734 | 8192 | public  | t1      | idx_t1_2 |     2745 |         90 | f
         2 |            2 | 8192 | public  | t2      | idx_t2   |        2 |         90 | f
(4 rows)
-----------------------------------  


步骤7------------------------------------------------------
根据relpages和est_pages算出来多余的空间


SELECT current_database(), nspname AS schemaname, tblname, idxname, bs*(relpages)::bigint AS real_size,
  bs*(relpages-est_pages)::bigint AS extra_size,
  100 * (relpages-est_pages)::float / relpages AS extra_pct,
  fillfactor,
  CASE WHEN relpages > est_pages_ff
    THEN bs*(relpages-est_pages_ff)
    ELSE 0
  END AS bloat_size,
  100 * (relpages-est_pages_ff)::float / relpages AS bloat_pct,
  is_na
  -- , 100-(pst).avg_leaf_density AS pst_avg_bloat, est_pages, index_tuple_hdr_bm, maxalign, pagehdr, nulldatawidth, nulldatahdrwidth, reltuples, relpages -- (DEBUG INFO)
FROM  relation_stats
ORDER BY nspname, tblname, idxname;



--------------------------------------------------------------------
