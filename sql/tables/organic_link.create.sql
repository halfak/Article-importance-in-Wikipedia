CREATE TABLE IF NOT EXISTS staging.organic_link (
    from_id         INT UNSIGNED,
    to_namespace    INT,
    to_title        VARBINARY(255),
    KEY(from_id),
    KEY(to_namespace, to_title)
);
SELECT NOW(), COUNT(*) FROM staging.organic_link;
