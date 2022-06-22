explain
SELECT c.oid, c.relname AS table_name, u.usename AS owner, n.nspname AS schema
FROM pg_class c
LEFT JOIN pg_user u
ON c.relowner=u.usesysid
LEFT JOIN pg_namespace n
ON c.relnamespace=n.oid
LEFT JOIN pg_partition_rule ppr
ON c.oid=ppr.parchildrelid
WHERE c.oid IN (select oid from pg_class)
AND true
AND ppr.parchildrelid is null;

explain
SELECT c.oid, c.relname AS table_name, u.usename AS owner, n.nspname AS schema
FROM pg_class c
LEFT JOIN pg_user u
ON c.relowner=u.usesysid
LEFT JOIN pg_namespace n
ON c.relnamespace=n.oid
WHERE c.oid IN (select oid from pg_class)
AND c.oid NOT IN (select parchildrelid from pg_partition_rule);