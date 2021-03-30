library(ggplot2)

args = commandArgs(trailingOnly = TRUE)

sf = args[1]
node = args[2]

if (node == "person" || node == "all") {
    cat("plot person degree\n")
  dat = read.csv(paste0("./data/person.csv"), header = TRUE)

  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white", bins=13) +
    theme_bw() +
    ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 16)
      ) + scale_y_log10()
  )

  ggsave(paste0("./graphics/person_degree_sf", sf, "_log_y.pdf"))
}

if (node == "forum" || node == "all") {
        cat("plot forum degree\n")
  dat = read.csv(paste0("./data/forum.csv"), header = TRUE)

  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white", bins=13) +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 16)
      ) + scale_y_log10()
  )

  ggsave(paste0("./graphics/forum_degree_sf", sf, "_log_y.pdf"))
}

if (node == "post" || node == "all") {
    cat("plot post degree\n")
  dat = read.csv(paste0("./data/post.csv"), header = TRUE)
  max(dat$degree)
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white", bins=20) +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 16)
      ) + scale_y_log10()
  )

  ggsave(paste0("./graphics/post_degree_sf", sf, "_log_y.pdf"))
}

if (node == "comment" || node == "all") {
    cat("plot comment degree\n")

  dat = read.csv(paste0("./data/comment.csv"), header = TRUE)
  max(dat$degree)
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white" , bins=20) +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 16)
      ) + scale_y_log10()
  )

  ggsave(paste0("./graphics/comment_degree_sf", sf, "_log_y.pdf"))
}
