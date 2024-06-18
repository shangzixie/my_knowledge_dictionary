CREATE OR REPLACE FUNCTION create_index_bloat_situation () RETURNS void AS $$
DECLARE
    tableName TEXT;
BEGIN
    for i in 1..100 LOOP
        tableName := 'a' || substr(md5(random()::text), 0, 25);
        EXECUTE 'CREATE TABLE '|| tableName || ' (
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
            f4 int,
            g int, h int, i int, j int, k int, l int, m int, n int , o int, p int, q int, r int, s int) DISTRIBUTED BY (c1);';
        EXECUTE 'DROP TABLE '||tableName||';';
    END LOOP;
END;
$$ LANGUAGE plpgsql;
