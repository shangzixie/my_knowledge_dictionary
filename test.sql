SELECT MAX(db.oid) AS dbid,
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples),
				MAX(mp.rel_oid) AS reloid,
				(
					GREATEST(
					    SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					) - LEAST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					)
				) / GREATEST(
					SUM(mp.planrows),
					SUM(sp.tuple_count+sp.ntuples)
				) * CASE WHEN MAX(mp.condition) = '' THEN 1 ELSE 0 END AS no_condition_factor,
				(
					GREATEST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					) - LEAST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					)
				) / GREATEST(
					SUM(mp.planrows),
					SUM(sp.tuple_count+sp.ntuples)
				) * CASE WHEN MAX(mp.condition) != '' THEN 1 ELSE 0 END AS condition_factor,
				CASE WHEN MAX(mp.condition) = '' THEN 1 ELSE 0 END AS no_condition_counter,
				CASE WHEN MAX(mp.condition) != '' THEN 1 ELSE 0 END AS condition_counter
				FROM gpmetrics.gpcc_plannode_history AS mp,
						gpmetrics.gpcc_plannode_history AS sp,
						gpmetrics.gpcc_queries_history AS q,
						gpmetrics.gpcc_table_info AS info,
						pg_database AS db
				WHERE mp.node_type LIKE '%%Scan' AND mp.rel_oid != 0 AND mp.segid = -1 AND sp.segid != -1
					AND mp.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND sp.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND q.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND mp.nodeid = sp.nodeid AND mp.ssid = sp.ssid AND mp.tmid = sp.tmid AND mp.ccnt = sp.ccnt
					AND q.ssid = mp.ssid AND q.tmid = mp.tmid AND q.ccnt = mp.ccnt
					AND info.dbid = db.oid AND info.relid = mp.rel_oid
					AND (info.last_analyze IS NULL
						OR (q.tsubmit > info.last_analyze
							AND (GREATEST(info.last_ins, info.last_del, info.last_upd) IS NULL
								OR GREATEST(info.last_ins, info.last_del, info.last_upd) > info.last_analyze
							)
						)
					)
					AND mp.index_name = '' -- filter index scan
					AND info.relstorage != 'x' -- filter external table
					AND db.datname = q.db
				GROUP BY mp.tmid,mp.ssid,mp.ccnt,mp.nodeid;

	SELECT dbid,
			reloid,
			CASE
				WHEN SUM(no_condition_counter) = 0 THEN AVG(condition_factor)
				WHEN SUM(condition_counter) = 0 THEN AVG(no_condition_factor)
				ELSE SUM(no_condition_factor) / SUM(no_condition_counter) * 0.7 + SUM(condition_factor) / SUM(condition_counter) * 0.3
			END AS factor
			FROM
			(SELECT MAX(db.oid) AS dbid,
				MAX(mp.rel_oid) AS reloid,
				(
					GREATEST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					) - LEAST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					)
				) / GREATEST(
					SUM(mp.planrows),
					SUM(sp.tuple_count+sp.ntuples)
				) * CASE WHEN MAX(mp.condition) = '' THEN 1 ELSE 0 END AS no_condition_factor,
				(
					GREATEST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					) - LEAST(
						SUM(mp.planrows),
						SUM(sp.tuple_count+sp.ntuples)
					)
				) / GREATEST(
					SUM(mp.planrows),
					SUM(sp.tuple_count+sp.ntuples)
				) * CASE WHEN MAX(mp.condition) != '' THEN 1 ELSE 0 END AS condition_factor,
				CASE WHEN MAX(mp.condition) = '' THEN 1 ELSE 0 END AS no_condition_counter,
				CASE WHEN MAX(mp.condition) != '' THEN 1 ELSE 0 END AS condition_counter
				FROM gpmetrics.gpcc_plannode_history AS mp,
						gpmetrics.gpcc_plannode_history AS sp,
						gpmetrics.gpcc_queries_history AS q,
						gpmetrics.gpcc_table_info AS info,
						pg_database AS db
				WHERE mp.node_type LIKE '%%Scan' AND mp.rel_oid != 0 AND mp.segid = -1 AND sp.segid != -1
					AND mp.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND sp.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND q.ctime >= CURRENT_TIMESTAMP::timestamp(0) without time zone - INTERVAL '30 days'
					AND mp.nodeid = sp.nodeid AND mp.ssid = sp.ssid AND mp.tmid = sp.tmid AND mp.ccnt = sp.ccnt
					AND q.ssid = mp.ssid AND q.tmid = mp.tmid AND q.ccnt = mp.ccnt
					AND info.dbid = db.oid AND info.relid = mp.rel_oid
					AND (info.last_analyze IS NULL
						OR (q.tsubmit > info.last_analyze
							AND (GREATEST(info.last_ins, info.last_del, info.last_upd) IS NULL
								OR GREATEST(info.last_ins, info.last_del, info.last_upd) > info.last_analyze
							)
						)
					)
					AND mp.index_name = '' -- filter index scan
					AND info.relstorage != 'x' -- filter external table
					AND db.datname = q.db
				GROUP BY mp.tmid,mp.ssid,mp.ccnt,mp.nodeid
			) AS table_factor
		GROUP BY dbid,reloid;



SET gpcc.enable_query_profiling to on;
SET gpcc.enable_send_instrument to on;
SET search_path TO recommendation;
CREATE TABLE recommendation.accuracy2 (c1 int) DISTRIBUTED BY (c1);
INSERT INTO recommendation.accuracy2 SELECT generate_series(1, 1000);
ANALYZE recommendation.accuracy2;
select pg_sleep(120);
INSERT INTO recommendation.accuracy2 SELECT generate_series(1, 1000);
SELECT * FROM recommendation.accuracy2

select ctime, tmid, ssid, ccnt, query_text from gpmetrics.gpcc_queries_history where query_text like '%accuracy2%';

Select query.query_text, plannode.node_type, plannode.status, plannode.planrows, plannode.ntuples, plannode.tuple_count
from gpmetrics.gpcc_queries_history as query inner join gpmetrics.gpcc_plannode_history as plannode on query.tmid = plannode.tmid and query.ssid = plannode.ssid AND query.ccnt = plannode.ccnt
where query.query_text LIKE '%SELECT * FROM accuracy2%'
order by plannode.ctime desc;

Select query.query_text, plannode.node_type, plannode.status, plannode.planrows, plannode.ntuples, plannode.tuple_count from gpmetrics.gpcc_queries_history as query inner join gpmetrics.gpcc_plannode_history as plannode on query.tmid = plannode.tmid and query.ssid = plannode.ssid AND query.ccnt = plannode.ccnt
order by plannode.ctime desc;

select * from gpmetrics.gpcc_table_info where table_name = 'accuracy2' and schema='recommendation';

			ar.Select("accuracy").From("gpmetrics.gpcc_table_info t").InnerJoin("pg_database d").On("t.dbid = d.oid").
				Where("schema = ?", schemaName).And("datname = ?", "gpperfmon").And("table_name = ?", "accuracy2")
			select accuracy from gpmetrics.gpcc_table_info t inner join pg_database d on t.dbid=d.oid where schema = 'recommendation' and datname = 'gpperfmon' and table_name = 'accuracy2';

truncate gpmetrics.gpcc_plannode_history;
truncate gpmetrics.gpcc_queries_history;
truncate gpmetrics.gpcc_table_info;
drop schema recommendation CASCADE;


CREATE TABLE recommendation.test1 (c1 int) DISTRIBUTED BY (c1);
INSERT INTO recommendation.test1 SELECT generate_series(1, 1000);
select now();
select oid from pg_class where relname='test1';
select * from pg_stat_last_operation where objid=314526;


select relid, last_analyze from gpmetrics.gpcc_table_info where table_name = 'test' and schema = 'recommendation';


select pg_sleep(30);
