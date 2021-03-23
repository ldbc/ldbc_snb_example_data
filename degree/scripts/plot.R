library(ggplot2)
dat = read.csv("./data/person.csv", header = TRUE)

invisible(ggplot(data=dat, aes(x=degree)) +
  geom_histogram(color="black", fill="white") +
  theme_bw() +
  ggtitle("SF1") +
  theme(plot.title = element_text(hjust = 0.5),
        text = element_text(size = 12)) + scale_y_log10())

ggsave("./graphics/person_degree_sf1_log_y.pdf")
