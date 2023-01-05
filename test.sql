CREATE TABLE gpmetrics.gpcc_index_info (
	  dbid 						OID
	, database 					VARCHAR(64)
	, schema 					VARCHAR(64)
	, table_oid 				OID
	, relation_name				VARCHAR(64)
	, index_oid 				OID
	, index_name				VARCHAR(64)
	, real_size					BIGINT
	, extra_size				BIGINT
	, fillfactor				INT
	, index_bloat_space			BIGINT
	, index_bloat_rate			DOUBLE PRECISION
	, is_na						BOOLEAN
	, last_scan_ts				TIMESTAMP WITH TIME ZONE
	, last_reindexed			TIMESTAMP WITH TIME ZONE
) DISTRIBUTED BY (dbid, table_oid, index_oid);