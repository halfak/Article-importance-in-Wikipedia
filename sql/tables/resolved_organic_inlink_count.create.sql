CREATE TABLE IF NOT EXISTS staging.resolved_organic_inlink_count (
    page_id                 INT UNSIGNED,
    inlinks                 INT,
    direct_inlinks          INT,
    inlinks_from_redirects  INT,
    redirects               INT,
    PRIMARY KEY(page_id)
);
SELECT NOW(), COUNT(*) FROM staging.resolved_organic_inlink_count;
