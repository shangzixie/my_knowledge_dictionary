SELECT pg_class.relname, pg_stat_last_operation.*
FROM pg_stat_last_operation
INNER JOIN pg_class
ON pg_class.oid=pg_stat_last_operation.objid
WHERE pg_stat_last_operation.stasubtype = 'REINDEX';


SELECT pg_class.relname, pg_class.oid, pg_stat_last_operation.statime
FROM pg_stat_last_operation
INNER JOIN pg_class
ON pg_class.oid=pg_stat_last_operation.objid
WHERE pg_stat_last_operation.stasubtype = 'REINDEX';


create table test_5 (
    a int,
    b int,
    c int,
    d int,
    e int,
    f int,
    a1 int,
    b1 int,
    c1 int,
    d1 int,
    e1 int,
    f1 int,
    a2 int,
    b2 int,
    c2 int,
    d2 int,
    e2 int,
    f2 int,
    a3 int,
    b3 int,
    c3 int,
    d3 int,
    e3 int,
    f3 int,
    g int, h int, i int, j int, k int, l int, m int, n int , o int, p int, q int, r int, s int);


CREATE OR REPLACE FUNCTION gpcc_schema.analyze_schema_tables (
    IN schema_name TEXT
)
RETURNS INTEGER AS
$$
DECLARE
    tab RECORD;
    table_count INTEGER;
BEGIN
    table_count = 0;
    for tab in (select t.relname::varchar AS table_name
                FROM pg_class t
                JOIN pg_namespace n ON n.oid = t.relnamespace
                WHERE t.relkind = 'r' and n.nspname::varchar = schema_name
                order by 1)

    LOOP
        EXECUTE format('ANALYZE %I.%I', schema_name, tab.table_name);
        table_count = table_count + 1;
    END LOOP;
    RETURN table_count;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION gpcc_schema.analyze_schema_tables(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION gpcc_schema.analyze_schema_tables(TEXT) TO gpmon;


SELECT
    tbloid,
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
FROM (
    SELECT
        idxoid,
        tbloid,
        coalesce(1 +
            ceil(reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float)), 0
        ) AS est_pages,
        coalesce(1 +
            ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0
        ) AS est_pages_ff,
        bs,
        nspname,
        tblname,
        idxname,
        relpages,
        fillfactor,
        is_na
    FROM (
        SELECT maxalign, bs, nspname, tblname, idxname, reltuples, relpages, idxoid, fillfactor, tbloid,
            ( index_tuple_hdr_bm +
                maxalign -
                CASE
                    WHEN index_tuple_hdr_bm%maxalign = 0 THEN maxalign
                    ELSE index_tuple_hdr_bm%maxalign
                END
                + nulldatawidth + maxalign -
                CASE
                    WHEN nulldatawidth = 0 THEN 0
                    WHEN nulldatawidth::integer%maxalign = 0 THEN maxalign
                    ELSE nulldatawidth::integer%maxalign
                END
            )::numeric AS nulldatahdrwidth,
            pagehdr,
            pageopqdata,
            is_na
        FROM (
            SELECT
                n.nspname,
                ct.relname AS tblname,
                i.idxname,
                i.reltuples,
                i.relpages,
                i.idxoid,
                i.tbloid,
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
                CASE WHEN max(coalesce(s.stanullfrac,0)) = 0
                    THEN 2 -- IndexTupleData size
                    ELSE 2 + (( 32 + 8 - 1 ) / 8) -- IndexTupleData size + IndexAttributeBitMapData size ( max num filed per index + 8 - 1 /8)
                END AS index_tuple_hdr_bm,
                /* data len: we remove null values save space using it fractionnal part from stats */
                sum( (1-coalesce(s.stanullfrac, 0)) * coalesce(s.stawidth, 1024)) AS nulldatawidth,
                max( CASE WHEN a.atttypid = 'pg_catalog.name'::regtype THEN 1 ELSE 0 END ) > 0 AS is_na
            FROM (
                SELECT
                    idxname,
                    reltuples,
                    relpages,
                    tbloid,
                    idxoid,
                    fillfactor,
                    CASE WHEN indkey[i]=0 THEN idxoid ELSE tbloid END AS att_rel,
                    CASE WHEN indkey[i]=0 THEN i ELSE indkey[i] END AS att_pos
                FROM (
                    SELECT
                        idxname,
                        reltuples,
                        relpages,
                        tbloid,
                        idxoid,
                        fillfactor,
                        indkey,
                        generate_series(1,indnatts) AS i
                    FROM (
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
                        AND ci.relpages > 0
                    ) AS idx_data
                ) AS idx_data_cross
            ) i
            JOIN pg_attribute a ON a.attrelid = i.att_rel AND a.attnum = i.att_pos
            JOIN pg_statistic s ON s.starelid = i.att_rel AND s.staattnum = i.att_pos
            JOIN pg_class ct ON ct.oid = i.tbloid
            JOIN pg_namespace n ON ct.relnamespace = n.oid
            GROUP BY 1,2,3,4,5,6,7,8,9,10
        ) AS rows_data_stats
    ) AS rows_hdr_pdg_stats
) AS relation_stats
LEFT JOIN (
    SELECT pg_class.relname, pg_class.oid as oid, pg_stat_last_operation.statime as last_reindexed
    FROM pg_stat_last_operation
    INNER JOIN pg_class
    ON pg_class.oid=pg_stat_last_operation.objid
    WHERE pg_stat_last_operation.stasubtype = 'REINDEX'
) AS last_operation
ON relation_stats.idxoid = last_operation.oid
WHERE relpages-est_pages_ff >= 0
ORDER BY bloat_size desc, bloat_size desc, idxname;