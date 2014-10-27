CREATE TABLE IF NOT EXISTS staging.resolved_view_count (
    page_id                 INT UNSIGNED,
    view                    INT,
    direct_view             INT,
    view_from_redirects     INT,
    redirects               INT,
    PRIMARY KEY(page_id)
);
SELECT NOW(), COUNT(*) FROM staging.resolved_view_count;
