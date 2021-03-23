library(ggplot2)

args = commandArgs(trailingOnly = TRUE)

sf = args[1]
node = args[2]

if (node == "person" || node == "all") {
  dat = read.csv(paste0("./data/", node , ".csv"), header = TRUE)
  
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white") +
      theme_bw() +
      ggtitle("SF1") +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 12)
      ) + scale_y_log10()
  )
  
  ggsave(paste0("./graphics/", node, "_degree_sf", sf, "_log_y.pdf"))
}