

we added a access_tables_info column to gpmetrics.gpcc_queries_history.

column	type	null	default	description
access_tables_info	INTEGER[]	not null	'{}'::INTEGER[]	the table oids of the query accessed.