dbstore = -h analytics-store.eqiad.wmnet -u research


######################### Importance class #####################################
datasets/importance_classification.tsv: sql/importance_classification.sql
	cat sql/importance_classification.sql | \
	mysql $(dbstore) enwiki > \
	datasets/importance_classification.tsv

datasets/tables/importance_classification.created: \
		sql/tables/importance_classification.create.sql
	cat sql/tables/importance_classification.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/importance_classification.created

datasets/tables/importance_classification.loaded: \
		datasets/tables/importance_classification.created \
		datasets/importance_classification.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE importance_classification" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/importance_classification.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM importance_classification" > \
	datasets/tables/importance_classification.loaded

######################### Inlink count #########################################
datasets/inlink_count.tsv: sql/inlink_count.sql
	cat sql/inlink_count.sql | \
	mysql $(dbstore) enwiki > \
	datasets/inlink_count.tsv
	
datasets/tables/inlink_count.created: \
		sql/tables/inlink_count.create.sql
	cat sql/tables/inlink_count.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/inlink_count.created

datasets/tables/inlink_count.loaded: \
		datasets/tables/inlink_count.created \
	datasets/inlink_count.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE inlink_count" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/inlink_count.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM inlink_count" > \
	datasets/tables/inlink_count.loaded

datasets/resolved_inlink_count.tsv:\
		datasets/tables/inlink_count.loaded \
		sql/resolved_inlink_count.sql
	cat sql/resolved_inlink_count.sql | \
	mysql $(dbstore) enwiki > \
	datasets/resolved_inlink_count.tsv
	
datasets/tables/resolved_inlink_count.created: \
		sql/tables/resolved_inlink_count.create.sql
	cat sql/tables/resolved_inlink_count.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/resolved_inlink_count.created

datasets/tables/resolved_inlink_count.loaded: \
		datasets/tables/resolved_inlink_count.created \
		datasets/resolved_inlink_count.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE resolved_inlink_count" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/resolved_inlink_count.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM resolved_inlink_count" > \
	datasets/tables/resolved_inlink_count.loaded

datasets/organic_link.tsv: importance/extract_organic_links.py
	./extract_organic_links \
		--api=https://en.wikipedia.org/w/api.php \
		--threads=35 \
/mnt/data/xmldatadumps/public/enwiki/20141106/enwiki-20141106-pages-articles*.xml-*.bz2 > \
	datasets/organic_link.tsv

datasets/tables/organic_link.created: datasets/organic_link.tsv \
		sql/tables/organic_link.create.sql
		cat sql/tables/organic_link.create.sql | \
		mysql $(dbstore) enwiki > \
		datasets/tables/organic_link.created

datasets/tables/organic_link.loaded: \
		datasets/tables/organic_link.created \
		datasets/organic_link.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE organic_link" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/organic_link.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM organic_link" > \
	datasets/tables/organic_link.loaded

datasets/tables/organic_inlink_count.loaded: datasets/tables/organic_link.loaded
	cat sql/tables/organic_inlink_count.create_load.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/organic_inlink_count.loaded

datasets/resolved_organic_inlink_count.tsv:\
		datasets/tables/organic_inlink_count.loaded \
		sql/resolved_organic_inlink_count.sql
	cat sql/resolved_organic_inlink_count.sql | \
	mysql $(dbstore) enwiki > \
	datasets/resolved_organic_inlink_count.tsv
	
datasets/tables/resolved_organic_inlink_count.created: \
		sql/tables/resolved_organic_inlink_count.create.sql
	cat sql/tables/resolved_organic_inlink_count.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/resolved_organic_inlink_count.created

datasets/tables/resolved_organic_inlink_count.loaded: \
		datasets/tables/resolved_organic_inlink_count.created \
		datasets/resolved_organic_inlink_count.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE resolved_organic_inlink_count" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/resolved_organic_inlink_count.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM resolved_organic_inlink_count" > \
	datasets/tables/resolved_organic_inlink_count.loaded

######################### Quality classification ###############################
datasets/quality_classification.tsv: sql/quality_classification.sql
	cat sql/quality_classification.sql | \
	mysql $(dbstore) enwiki > \
	datasets/quality_classification.tsv
	
datasets/tables/quality_classification.created: \
		sql/tables/quality_classification.create.sql
	cat sql/tables/quality_classification.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/quality_classification.created

datasets/tables/quality_classification.loaded: \
		datasets/tables/quality_classification.created \
		datasets/quality_classification.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE quality_classification" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/quality_classification.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM quality_classification" > \
	datasets/tables/quality_classification.loaded


########################## Page views ##########################################
datasets/page_name_views_dupes.tsv: importance/sum_pageviews.py
	./sum_pageviews datasets/hourly_pageviews/pagecounts-201409*.gz \
			--api=https://en.wikipedia.org/w/api.php\
			--projects=en > \
	datasets/page_name_views_dupes.tsv

datasets/tables/page_name_views_dupes.created: \
		sql/tables/page_name_views_dupes.create.sql
	cat sql/tables/page_name_views_dupes.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/page_name_views_dupes.created

datasets/tables/page_name_views_dupes.loaded: \
		datasets/tables/page_name_views_dupes.created \
		datasets/page_name_views_dupes.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE page_name_views_dupes" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/page_name_views_dupes.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM page_name_views_dupes" > \
	datasets/tables/page_name_views_dupes.loaded

datasets/resolved_view_count.tsv:\
		datasets/tables/page_name_views_dupes.loaded \
		sql/resolved_view_count.sql
	cat sql/resolved_view_count.sql | \
	mysql $(dbstore) enwiki > \
	datasets/resolved_view_count.tsv
	
datasets/tables/resolved_view_count.created: \
		sql/tables/resolved_view_count.create.sql
	cat sql/tables/resolved_view_count.create.sql | \
	mysql $(dbstore) enwiki > \
	datasets/tables/resolved_view_count.created

datasets/tables/resolved_view_count.loaded: \
		datasets/tables/resolved_view_count.created \
	datasets/resolved_view_count.tsv
	mysql $(dbstore) staging \
		-e "TRUNCATE resolved_view_count" && \
	mysqlimport $(dbstore) --local staging --ignore-lines=1 \
		datasets/resolved_view_count.tsv && \
	mysql $(dbstore) staging \
		-e "SELECT NOW(), COUNT(*) FROM resolved_view_count" > \
	datasets/tables/resolved_view_count.loaded

######################## Article stats #########################################
datasets/article_stats.tsv: sql/article_stats.sql
	cat sql/article_stats.sql | \
	mysql $(dbstore) enwiki > \
	datasets/article_stats.tsv
	
datasets/article_stats.sample.tsv: datasets/article_stats.tsv
	(head -n1 datasets/article_stats.tsv; \
	tail -n+2 datasets/article_stats.tsv | \
	shuf -n 500000) > \
	datasets/article_stats.sample.tsv
