CREATE TABLE IF NOT EXISTS staging.importance_classification (
    page_id         INT UNSIGNED,
    page_namespace  INT,
    page_title      VARBINARY(255),
    category        VARBINARY(255),
    cl_type         ENUM('page','subcat','file'),
    last_update     VARBINARY(14),
    importance      ENUM('Top', 'High', 'Mid', 'Low', 'Unknown'),
    PRIMARY KEY(page_id, category),
    KEY(last_update, importance)
);
SELECT NOW(), COUNT(*) FROM staging.importance_classification;
