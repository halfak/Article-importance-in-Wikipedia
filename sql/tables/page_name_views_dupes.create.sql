CREATE TABLE IF NOT EXISTS staging.page_name_views_dupes (
    page_namespace  INT,
    page_title      VARBINARY(255),
    views           INT,
    KEY(page_namespace, page_title)
);
SELECT NOW(), COUNT(*) FROM staging.page_name_views_dupes;
