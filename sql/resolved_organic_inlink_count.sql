SELECT
    article.page_id,
    article.inlinks + SUM(redirect.inlinks) AS inlinks,
    article.inlinks AS direct_inlinks,
    SUM(redirect.inlinks) AS inlinks_from_redirects,
    COUNT(redirect.page_id) AS redirects
FROM staging.organic_inlink_count article
LEFT JOIN staging.organic_inlink_count redirect ON
    redirect.redirect_id = article.page_id
WHERE article.redirect_id IS NULL
GROUP BY article.page_id;
