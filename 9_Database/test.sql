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


