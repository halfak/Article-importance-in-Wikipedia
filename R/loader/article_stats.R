source("util.R")
source("env.R")

load_article_stats = tsv_loader(
    paste(DATA_DIR, "article_stats.sample.tsv", sep="/"),
    "ARTICLE_STATS"
)
