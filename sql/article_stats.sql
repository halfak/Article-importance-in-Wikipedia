SELECT
    page_id,
    page_title,
    MAX(importance) AS max_importance,
    MIN(importance) AS min_importance,
    AVG(importance) AS mean_importance,
    IFNULL(inlinks, 0) AS inlinks,
    IFNULL(direct_inlinks, 0) AS direct_inlinks,
    IFNULL(inlinks_from_redirects, 0) AS inlinks_from_redirects,
    IFNULL(views, 0) AS views,
    IFNULL(direct_views, 0) AS direct_views,
    IFNULL(views_from_redirects, 0) AS views_from_redirects
FROM staging.importance_classification
LEFT JOIN staging.resolved_inlink_count USING (page_id)
LEFT JOIN staging.resolved_view_count USING (page_id)
WHERE page_namespace = 0
GROUP BY page_id;
