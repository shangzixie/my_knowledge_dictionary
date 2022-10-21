Expected
        <string>: COPY (
        SELECT
        	row_number() over(ORDER BY index_bloat_space DESC, index_bloat_rate DESC, schema, relation_name, index_name) AS Rank,
        	database,
        	schema,
        	relation_name,
        	index_name,
        	real_size,
        	index_bloat_space,
        	index_bloat_rate,
        	last_reindexed,
        	last_scan_ts
        FROM (
        	SELECT
        		database,
        		schema,
        		table_oid,
        		relation_name,
        		index_oid,
        		index_name,
        		real_size,
        		index_bloat_space,
        		index_bloat_rate,
        		last_reindexed,
        		last_scan_ts,
        		is_na
        	FROM gpmetrics.gpcc_index_scan_info AS t
        	WHERE index_bloat_rate >= 50.000000 AND is_na is FALSE
        		AND t.dbid = 123
        		AND t.schema = 'test'
        ) AS dt
        ORDER BY 1
        LIMIT 1000) TO 'gpmetrics/report-for-index-bloat.csv' WITH CSV DELIMITER E',' HEADER
    to contain substring
        <string>: COPY (SELECT
        							row_number() over(ORDER BY index_bloat_space DESC, index_bloat_rate DESC, schema, relation_name, index_name) AS Rank,
        							database,
        							schema,
        							relation_name,
        							index_name,
        							real_size,
        							index_bloat_space,
        							index_bloat_rate,
        							last_reindexed,
        							last_scan_ts
        						FROM (
        							SELECT
        								database,
        								schema,
        								table_oid,
        								relation_name,
        								index_oid,
        								index_name,
        								real_size,
        								index_bloat_space,
        								index_bloat_rate,
        								last_reindexed,
        								last_scan_ts,
        								is_na
        							FROM gpmetrics.gpcc_index_scan_info AS t
        							WHERE index_bloat_rate >= 0.5 AND is_na is FALSE
        							AND t.dbid = 12
        							AND t.schema = 'testschema'
        						) AS dt
        						ORDER BY 1
        						LIMIT 100
        ) TO 'gpmetrics/report-for-index-bloat.csv' WITH CSV DELIMITER E',' HEADER
