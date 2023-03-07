SELECT MAX(db.oid) AS dbid,
                    MAX(mp.rel_oid) AS reloid,
                    (
                        GREATEST(
                            %[1]s(mp.planrows),
                            SUM(sp.tuple_count+sp.ntuples)
                        ) - LEAST(
                            %[1]s(mp.planrows),
                            SUM(sp.tuple_count+sp.ntuples)
                        )
                    ) / GREATEST(
                        %[1]s(mp.planrows),
                        SUM(sp.tuple_count+sp.ntuples)
                    ) * CASE WHEN MAX(mp.condition) = '' THEN 1 ELSE 0 END AS no_condition_factor,
                    (
                        GREATEST(
                            %[1]s(mp.planrows),
                            SUM(sp.tuple_count+sp.ntuples)
                        ) - LEAST(
                            %[1]s(mp.planrows),
                            SUM(sp.tuple_count+sp.ntuples)
                        )
                    ) / GREATEST(
                        %[1]s(mp.planrows),
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
                        AND mp.index_name = '' -- filter index scan
                        AND info.relstorage != 'x' -- filter external table
                        AND db.datname = q.db
                    GROUP BY mp.tmid,mp.ssid,mp.ccnt,mp.nodeid