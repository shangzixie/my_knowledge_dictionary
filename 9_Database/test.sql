SELECT
            database::TEXT,
            schema::TEXT,
            relation_name::TEXT,
            dbid,
            table_oid
            FROM gpmetrics.gpcc_index_scan_info AS t
            WHERE index_bloat_rate >= 50 AND is_na is FALSE
        ORDER BY index_bloat_space DESC, index_bloat_rate DESC, schema, relation_name, index_name


    SELECT
                database::TEXT,
                schema::TEXT,
                relation_name::TEXT,
                dbid,
                table_oid
                FROM gpmetrics.gpcc_index_scan_info AS t
                WHERE index_bloat_rate >= 0.5 AND is_na is FALSE
            ORDER BY index_bloat_space DESC, index_bloat_rate DESC, schema, relation_name, index_name