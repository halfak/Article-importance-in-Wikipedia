CREATE TABLE staging.article_stats (
    page_id INT,
    page_title VARBINARY(255),
    max_importance VARCHAR(50),
    min_importance VARCHAR(50),
    mean_importance VARCHAR(50),
    inlinks INT,
    direct_inlinks INT,
    inlinks_from_redirects INT,
    organic_inlinks INT,
    organic_direct_inlinks INT,
    organic_inlinks_from_redirects INT,
    views INT,
    direct_views INT,
    views_from_redirects INT,
    PRIMARY KEY (page_id),
    KEY (page_title)
);

