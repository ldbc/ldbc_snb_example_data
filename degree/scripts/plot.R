library(ggplot2)

args = commandArgs(trailingOnly = TRUE)

sf = args[1]
node = args[2]

if (node == "person" || node == "all") {
  dat = read.csv(paste0("./data/person.csv"), header = TRUE)
  
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
  
  ggsave(paste0("./graphics/person_degree_sf", sf, "_log_y.pdf"))
}

if (node == "forum" || node == "all") {
  dat = read.csv(paste0("./data/forum.csv"), header = TRUE)
  
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white") +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 12) 
      ) + scale_y_log10()
  )
  
  ggsave(paste0("./graphics/forum_degree_sf",sf,".pdf"))
}

if (node == "post" || node == "all") {
  dat = read.csv(paste0("./data/post.csv"), header = TRUE)
  max(dat$degree)
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white") +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 12) 
      ) + scale_y_log10()
  )
  
  ggsave(paste0("./graphics/post_degree_sf", sf, "_log_y.pdf"))
}

if (node == "comment" || node == "all") {
  dat = read.csv(paste0("./data/comment.csv"), header = TRUE)
  max(dat$degree)
  invisible(
    ggplot(data = dat, aes(x = degree)) +
      geom_histogram(color = "black", fill = "white") +
      theme_bw() +
      ggtitle(paste0("SF",sf)) +
      theme(
        plot.title = element_text(hjust = 0.5),
        text = element_text(size = 12) 
      ) + scale_y_log10()
  )
  
  ggsave(paste0("./graphics/comment_degree_sf", sf, "_log_y.pdf"))
}