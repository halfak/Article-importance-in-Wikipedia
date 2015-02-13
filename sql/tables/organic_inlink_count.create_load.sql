CREATE TEMPORARY TABLE staging.proto_organic_inlink_count
SELECT
    to_namespace AS page_namespace,
    to_title AS page_title,
    COUNT(from_id) AS inlinks
FROM staging.organic_link
GROUP BY page_namespace, page_title;

CREATE UNIQUE INDEX namespace_title
ON staging.proto_organic_inlink_count (page_namespace, page_title);

DROP TABLE IF EXISTS staging.organic_inlink_count;
CREATE TABLE staging.organic_inlink_count
SELECT
    page.page_id,
    IFNULL(inlink_count.inlinks, 0) AS inlinks,
    redirect.page_id AS redirect_id
FROM page
LEFT JOIN staging.proto_organic_inlink_count inlink_count USING
    (page_namespace, page_title)
LEFT JOIN redirect redirectlink ON
    page_is_redirect AND
    redirectlink.rd_from = page_id
LEFT JOIN page redirect ON
    redirect.page_title = redirectlink.rd_title AND
    redirect.page_namespace = redirectlink.rd_namespace
WHERE page.page_namespace = 0;

CREATE UNIQUE INDEX page_idx ON staging.organic_inlink_count (page_id);

CREATE INDEX redirect_idx ON staging.organic_inlink_count (redirect_id);

SELECT COUNT(*), NOW() FROM staging.organic_inlink_count;
