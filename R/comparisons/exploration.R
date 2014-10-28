source("loader/article_stats.R")

article_stats = load_article_stats()
article_stats$standardized_importance = convert.factor(
    round(article_stats$mean_importance),
    list(
        "1" = "Top",
        "2" = "High",
        "3" = "Mid",
        "4" = "Low",
        "5" = "Unknown"
    )
)


svg("comparisons/plots/view_rate_density.by_wikiproject_importance.gt_zero.svg",
    height=5,
    width=7)
ggplot(
    article_stats[views>0,],
    aes(
        x=views,
        group=standardized_importance,
        fill=standardized_importance
    )
) +
geom_density(alpha=0.3) +
geom_vline(
    data=article_stats[views>0,
        list(median = median(views+1)),
        standardized_importance
    ],
    aes(
        xintercept=median,
        color=standardized_importance
    ),
) +
theme_bw() +
scale_x_log10("Views") +
scale_fill_discrete("Importance") +
scale_color_discrete("Importance")
dev.off()

svg("comparisons/plots/view_rate_density.by_wikiproject_importance.svg",
    height=5,
    width=7)
ggplot(
    article_stats,
    aes(
        x=views+1,
        group=standardized_importance,
        fill=standardized_importance
    )
) +
geom_density(alpha=0.3) +
geom_vline(
    data=article_stats[,
        list(median = median(views+1)),
        standardized_importance
    ],
    aes(
        xintercept=median,
        color=standardized_importance
    )
) +
theme_bw() +
scale_x_log10("Views") +
scale_fill_discrete("Importance") +
scale_color_discrete("Importance")
dev.off()

svg("comparisons/plots/inlink_density.by_wikiproject_importance.svg",
    height=5,
    width=7)
ggplot(
    article_stats,
    aes(
        x=inlinks+1,
        group=standardized_importance,
        fill=standardized_importance
    )
) +
geom_density(alpha=0.3) +
geom_vline(
    data=article_stats[,
        list(median = median(inlinks+1)),
        standardized_importance
    ],
    aes(
        xintercept=median,
        color=standardized_importance
    )
) +
theme_bw() +
scale_x_log10("Inlinks") +
scale_fill_discrete("Importance") +
scale_color_discrete("Importance")
dev.off()



svg("comparisons/plots/inlink_and_view_density.by_wikiproject_importance.svg",
    height=4,
    width=12)
ggplot(
    article_stats[sample(1:nrow(article_stats), 500000),],
    aes(
        x=inlinks+1,
        y=views+1,
        group=standardized_importance,
    )
) +
facet_wrap(~ standardized_importance, nrow=1) +
stat_density2d(
    aes(
        alpha=(..level..)+.2,
        fill=standardized_importance
    ),
    geom="polygon"
) +
geom_point(
    data=article_stats[,
        list(
            median.inlinks = median(inlinks+1),
            median.views = median(views+1)
        ),
        standardized_importance
    ],
    aes(
        x=median.inlinks,
        y=median.views,
        color=standardized_importance
    )
) +
theme_bw() +
scale_x_log10("Inlinks") +
scale_y_log10("Views") +
scale_fill_discrete("Importance") +
scale_color_discrete("Importance") +
scale_alpha_continuous(guide = F)
dev.off()
