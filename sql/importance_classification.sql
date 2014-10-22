SELECT 
  article.page_id, 
  article.page_namespace,
  article.page_title,
  cl.cl_type,
  cl.cl_to AS category,
  cl.cl_timestamp,
  SUBSTRING_INDEX(cl.cl_to, "-", 1) AS importance
FROM categorylinks cl
JOIN page tp ON 
  cl.cl_from = tp.page_id AND
  tp.page_namespace = 1
JOIN page article ON
  article.page_title = tp.page_title AND
  article.page_namespace = 0
WHERE
  cl.cl_to LIKE "Top-importance%articles" OR
  cl.cl_to LIKE "High-importance%articles" OR
  cl.cl_to LIKE "Mid-importance%articles" OR
  cl.cl_to LIKE "Low-importance%articles" OR
  cl.cl_to LIKE "Unknown-importance%articles";
