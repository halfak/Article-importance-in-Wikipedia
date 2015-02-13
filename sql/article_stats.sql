SELECT
    page_id,
    page_title,
    MIN(importance) AS max_importance, /* Note that max and min are reversed */
    MAX(importance) AS min_importance, /* due to the ENUM */
    AVG(importance) AS mean_importance,
    IFNULL(all_links.inlinks, 0) AS inlinks,
    IFNULL(all_links.direct_inlinks, 0) AS direct_inlinks,
    IFNULL(all_links.inlinks_from_redirects, 0) AS inlinks_from_redirects,
    IFNULL(organic.inlinks, 0) AS organic_inlinks,
    IFNULL(organic.direct_inlinks, 0) AS organic_direct_inlinks,
    IFNULL(organic.inlinks_from_redirects, 0) AS organic_inlinks_from_redirects,
    IFNULL(views, 0) AS views,
    IFNULL(direct_views, 0) AS direct_views,
    IFNULL(views_from_redirects, 0) AS views_from_redirects
FROM staging.importance_classification
LEFT JOIN staging.resolved_inlink_count all_links USING (page_id)
LEFT JOIN staging.resolved_organic_inlink_count organic USING (page_id)
LEFT JOIN staging.resolved_view_count USING (page_id)
WHERE page_namespace = 0
GROUP BY page_id;
