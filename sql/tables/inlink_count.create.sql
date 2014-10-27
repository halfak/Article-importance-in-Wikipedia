CREATE TABLE IF NOT EXISTS staging.inlink_count (
    page_id         INT UNSIGNED,
    inlinks         INT UNSIGNED,
    redirect_id     INT UNSIGNED,
    PRIMARY KEY(page_id),
    KEY(redirect_id)
);
SELECT NOW(), COUNT(*) FROM staging.inlink_count;
