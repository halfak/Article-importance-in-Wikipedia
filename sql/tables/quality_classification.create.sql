CREATE TABLE IF NOT EXISTS staging.quality_classification (
    page_id         INT UNSIGNED,
    page_namespace  INT,
    page_title      VARBINARY(255),
    category        VARBINARY(255),
    cl_type         ENUM('page','subcat','file'),
    last_update     VARBINARY(14),
    quality_class   ENUM('FA', 'A', 'GA', 'B', 'C', 'Start', 'Stub'),
    PRIMARY KEY(page_id, category),
    KEY(last_update, quality_class)
);
SELECT NOW(), COUNT(*) FROM staging.quality_classification;
