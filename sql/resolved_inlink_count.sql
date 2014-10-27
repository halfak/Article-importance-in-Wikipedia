SELECT
    article.page_id,
    article.inlinks + SUM(redirect.inlinks) AS inlinks,
    article.inlinks AS direct_inlinks,
    SUM(redirect.inlinks) AS inlinks_from_redirects,
    COUNT(redirect.page_id) AS redirects
FROM staging.inlink_count article
LEFT JOIN staging.inlink_count redirect ON
    redirect.redirect_id = article.page_id
WHERE article.redirect_id = 0
GROUP BY article.page_id;
