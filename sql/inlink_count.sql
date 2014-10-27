CREATE TEMPORARY TABLE staging.proto_inlink_count
SELECT
    pl_namespace AS page_namespace,
    pl_title AS page_title,
    COUNT(pl_from) AS inlinks
FROM pagelinks
GROUP BY pl_namespace, pl_title;

CREATE UNIQUE INDEX namespace_title
ON staging.proto_inlink_count (page_namespace, page_title);

SELECT
    page.page_id,
    IFNULL(inlink_count.inlinks, 0) AS inlinks,
    redirect.page_id AS redirect_id
FROM page
LEFT JOIN staging.proto_inlink_count inlink_count USING
    (page_namespace, page_title)
LEFT JOIN redirect redirectlink ON
    page_is_redirect AND
    redirectlink.rd_from = page_id
LEFT JOIN page redirect ON
    redirect.page_title = redirectlink.rd_title AND
    redirect.page_namespace = redirectlink.rd_namespace
WHERE page.page_namespace = 0;
