CREATE TABLE IF NOT EXISTS staging.resolved_view_count (
    page_id                  INT UNSIGNED,
    views                    INT,
    direct_views             INT,
    views_from_redirects     INT,
    redirects                INT,
    PRIMARY KEY(page_id)
);
SELECT NOW(), COUNT(*) FROM staging.resolved_view_count;
