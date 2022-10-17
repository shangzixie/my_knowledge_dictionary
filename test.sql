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
	last_scan_ts%[1], index_oid, table_oid
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
	WHERE index_bloat_rate >= 50 AND is_na is FALSE
) AS dt
ORDER BY 1



		SELECT
			nspname AS schema,
			tbloid AS table_oid,
			tblname AS relation_name,
			idxoid AS index_oid,
			idxname AS index_name,
			bs*(relpages)::bigint AS real_size,
			bs*(relpages-est_pages)::bigint AS extra_size,
			fillfactor,
			bs*(relpages-est_pages_ff) AS index_bloat_space,
			100 * (relpages-est_pages_ff)::float / relpages AS index_bloat_rate,
			is_na
		FROM (
		SELECT
			coalesce(1 + ceil(reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float)), 0) AS est_pages,
			coalesce(1 + ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0) AS est_pages_ff,
			bs,
			nspname,
			tblname,
			idxname,
			relpages,
			tbloid,
			idxoid,
			fillfactor,
			is_na
		FROM (
		SELECT
			maxalign,
			bs,
			nspname,
			tblname,
			idxname,
			reltuples,
			relpages,
			idxoid,
			tbloid,
			fillfactor,
			( index_tuple_hdr_bm +
				maxalign -
				CASE WHEN index_tuple_hdr_bm%maxalign = 0 THEN maxalign
					ELSE index_tuple_hdr_bm%maxalign
				END
				+ nulldatawidth + maxalign -
				CASE WHEN nulldatawidth = 0 THEN 0
					WHEN nulldatawidth::integer%maxalign = 0 THEN maxalign
					ELSE nulldatawidth::integer%maxalign
				END
			)::numeric AS nulldatahdrwidth,
			pagehdr,
			pageopqdata,
			is_na FROM (
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
          CASE
            WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
            ELSE 4
          END AS maxalign,
          24 AS pagehdr,
          20 AS pageopqdata,
          CASE
            WHEN max(coalesce(s.stanullfrac,0)) = 0
            THEN 6
            ELSE 6 + (( 32 + 8 - 1 ) / 8)
          END AS index_tuple_hdr_bm,
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
              AND ci.relpages > 0 ) AS idx_data ) AS idx_data_cross ) AS i
              JOIN pg_attribute a ON a.attrelid = i.att_rel AND a.attnum = i.att_pos
              JOIN pg_statistic s ON s.starelid = i.att_rel AND s.staattnum = i.att_pos
              JOIN pg_class ct ON ct.oid = i.tbloid
              JOIN pg_namespace n ON ct.relnamespace = n.oid
GROUP BY 1,2,3,4,5,6,7,8,9,10) AS rows_data_stats) AS rows_hdr_pdg_stats ) AS relation_stats
		WHERE relpages-est_pages_ff >= 0
		ORDER BY index_bloat_space DESC, index_bloat_rate DESC, schema, relation_name, index_name;