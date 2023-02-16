CREATE FUNCTION getfoo(int) RETURNS SETOF test_new_query.sales AS $$
    SELECT * FROM test_new_query.sales WHERE id = $1;
$$ LANGUAGE SQL;

CREATE FUNCTION sum_n_product_with_tab (x int, OUT sum int, OUT product int)
RETURNS SETOF record
AS $$
    SELECT $1 + test_new_query.y, $1 * test_new_query.y FROM test_new_query;
$$ LANGUAGE SQL;

CREATE TABLE foo (fooid int, foosubid int, fooname text);
INSERT INTO foo VALUES (1, 1, 'Joe');
INSERT INTO foo VALUES (1, 2, 'Ed');
INSERT INTO foo VALUES (2, 1, 'Mary');


UPDATE test_new_query
SET y = 20
WHERE y = 1;

UPDATE test_new_query
SET (y, z) = (20, 10)
WHERE y = 20;