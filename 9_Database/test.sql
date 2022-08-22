SELECT
    reltuples/floor((bs-pageopqdata-pagehdr)/(4+nulldatahdrwidth)::float) AS est_pages,
    coalesce(1 + ceil(reltuples/floor((bs-pageopqdata-pagehdr)*fillfactor/(100*(4+nulldatahdrwidth)::float))), 0
    ) AS est_pages_ff,
    bs,
    nspname,
    tblname,
    idxname,
    relpages,
    fillfactor,
    is_na

FROM rows_hdr_pdg_stats;