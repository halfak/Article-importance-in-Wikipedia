CREATE TABLE IF NOT EXISTS staging.page_name_views_dupes (
    page_namespace  INT,
    page_title      VARBINARY(255),
    views           INT
);
SELECT NOW(), COUNT(*) FROM staging.page_name_views_dupes;
