			drop schema if exists s1 CASCADE;
			create schema s1;
			create table s1.t1 (id int, ctx text) distributed by (id);
			create table s1.t2 (id int, year int, month int, day int) distributed by (id) partition by range (year) (START (2010) END (2018) EVERY (1), DEFAULT PARTITION other_years);
			insert into s1.t2 select id, id, id, id from generate_series(1, 20) id;
			insert into s1.t2 select 1, id, id, id from generate_series(1, 20) id;
			set optimizer=off;
			select *, pg_sleep(0.01) from s1.t2 a join s1.t2 b on a.id = a.id;

select r.rolname as user, b.rolname as level
From pg_catalog.pg_auth_members m
Join pg_catalog.pg_roles b On m.roleid = b.oid
Join pg_roles r On m.member = r.oid
Where r.rolname in ('nightly_selfonly', 'pgbencher') And b.rolname in ('gpcc_basic', 'gpcc_operator', 'gpcc_operator_basic', 'gpcc_operator_readonly');


SELECT
	r.rolname
	, r.level
	, rg.rsgname
FROM
(
	SELECT
		role.rolname
		, CASE WHEN bool_or(role.rolsuper) THEN 5 ELSE CASE WHEN max(a.rank) IS NOT NULL THEN max(a.rank) ELSE 1 END END AS level
	FROM pg_roles role
	LEFT JOIN
	(
		SELECT u.rolname, u.oid, rank
		FROM pg_authid u
		JOIN (
			SELECT 2 AS rank, 'gpcc_basic' AS rn
			UNION ALL
			SELECT 3, 'gpcc_operator_basic'
			UNION ALL
			SELECT 4, 'gpcc_operator'
			UNION ALL
			SELECT 3, 'gpcc_operator_readonly'
		) t ON u.rolname = t.rn
	) a
	ON pg_has_role(role.rolname, a.oid, 'member') AND NOT role.rolsuper
	WHERE role.rolcanlogin AND role.rolname NOT IN ('gpadmin', 'gpmon')
	GROUP BY role.rolname
) r
LEFT JOIN (
	SELECT rsgname, rolname, rolcanlogin
	FROM pg_resgroup
	LEFT JOIN pg_roles ON pg_resgroup.oid=pg_roles.rolresgroup
	ORDER BY pg_resgroup.oid
) rg
ON r.rolname = rg.rolname
WHERE true

select r.rolname, r.

SELECT rsgname, rolname
FROM pg_resgroup
LEFT JOIN pg_roles r ON pg_resgroup.oid=r.rolresgroup
WHERE rolname = ANY (ARRAY[])

select abalance from pgbench_accounts limit 1 --PGBenchQueryTest123
;

echo "select abalance from pgbench_accounts limit 1
--PGBenchQueryTest123
;" > /tmp/pgbench_query.sql

select nodeid, parent_nodeid, node_type, status, relation_name, rel_oid from gpmetrics.gpcc_plannode_history where ccnt = 11 and ssid = 346 and node_type != '' and status = 'NODE_DONE';

select q.query_text, p.nodeid, p.node_type, p.ssid, p.ccnt, p.status
from gpmetrics.gpcc_plannode_history p
inner join gpmetrics.gpcc_queries_history q on p.ssid = q.ssid and p.ccnt = q.ccnt
where q.db = 'pgbench' and p.node_type != ''
order by p.ssid, p.ccnt, p.nodeid;
