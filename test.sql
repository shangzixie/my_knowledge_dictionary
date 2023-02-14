CREATE FUNCTION getfoo(int) RETURNS SETOF test_new_query.sales AS $$
    SELECT * FROM test_new_query.sales WHERE id = $1;
$$ LANGUAGE SQL;

CREATE FUNCTION sum_n_product_with_tab (x int, OUT sum int, OUT product int)
RETURNS SETOF record
AS $$
    SELECT $1 + tab.y, $1 * tab.y FROM tab;
$$ LANGUAGE SQL;