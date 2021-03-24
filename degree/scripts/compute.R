library("DBI")
con = dbConnect(duckdb::duckdb(), ":ldbc:")

args = commandArgs(trailingOnly = TRUE)
node = args[1]

if (node == "person" || node == "all") {
  cat("computing person degree\n")
  
  # undirected edges
  invisible(
    dbExecute(
      con,
      "CREATE VIEW undirected_edges AS
    SELECT person1id, person2id FROM person_knows_person
    UNION ALL
    SELECT person2id, person1id FROM person_knows_person"
    )
  )
  
  # merge
  invisible(
    dbExecute(
      con,
      "CREATE VIEW person_degree AS
SELECT person1id AS pid, count(person2id) AS degree FROM undirected_edges GROUP BY person1id
UNION ALL
SELECT person.id AS pid, count(hasinterest_tag) AS degree FROM person, person_hasinterest_tag WHERE person.id = person_hasinterest_tag.id GROUP BY pid
UNION ALL
SELECT person.id AS pid, count(studyat_university) AS degree FROM person, person_studyat_university WHERE person.id = person_studyat_university.id GROUP BY pid
UNION ALL
SELECT person.id AS pid, count(workat_company) as degree FROM person, person_workat_company WHERE person.id = person_workat_company.id GROUP BY pid
UNION ALL
SELECT id AS pid, count(likes_post) as degree FROM person_likes_post GROUP BY pid
UNION ALL
SELECT id AS pid, count(likes_comment) as degree FROM person_likes_comment GROUP BY pid
UNION ALL
SELECT hasmember_person AS pid, count(id) as degree FROM forum_hasmember_person GROUP BY hasmember_person
UNION ALL
SELECT hasmoderator_person AS pid, count(id) as degree FROM forum GROUP BY hasmoderator_person
UNION ALL
SELECT hascreator_person AS pid, count(id) as degree FROM post GROUP BY hascreator_person
UNION ALL
SELECT hascreator_person AS pid, count(id) as degree FROM comment GROUP BY hascreator_person"
    )
  )
  
  # export
  invisible(
    dbExecute(
      con,
      "COPY (
SELECT pid, sum(degree) as degree FROM person_degree GROUP BY pid
)
TO './data/person.csv' WITH (HEADER 1, DELIMITER ',') "
    ))

} 

if (node == "post" || node == "all") {
  
  cat("computing post degree\n")
  
  invisible(dbExecute(
    con,
    "CREATE VIEW post_degree AS 
     SELECT id, count(hascreator_person) as degree FROM post GROUP BY id
     UNION ALL   
     SELECT id, count(forum_containerof) as degree FROM post GROUP BY id 
     UNION ALL
     SELECT id, count(hastag_tag) as degree FROM post_hastag_tag GROUP BY id
     UNION ALL
     SELECT likes_post AS id, count(*) as degree FROM person_likes_post GROUP BY likes_post
     UNION ALL
     SELECT replyof_post AS id, count(*) as degree FROM Comment WHERE replyof_post >= 0 GROUP BY replyof_post
  "
  ))
  
  # export
  invisible(
    dbExecute(
      con,
      "COPY ( SELECT id, sum(degree) as degree FROM post_degree GROUP BY id ) TO './data/post.csv' WITH (HEADER 1, DELIMITER ',') "
    ))
  
} 

if (node == "comment" || node == "all") {
  
  cat("computing comment degree\n")
  
  dbExecute(
    con,
    "CREATE VIEW comment_degree AS 
   SELECT id, count(hascreator_person) as degree FROM comment GROUP BY id
   UNION ALL   
   SELECT id, count(hastag_tag) as degree FROM comment_hastag_tag GROUP BY id
   UNION ALL
   SELECT likes_comment AS id, count(*) as degree FROM person_likes_comment GROUP BY likes_comment
   UNION ALL
   SELECT replyof_comment AS id, count(*) as degree FROM comment WHERE replyof_comment >= 0 GROUP BY replyof_comment
  "
  )
  
  # export
  invisible(
    dbExecute(
      con,
      "COPY ( SELECT id, sum(degree) as degree FROM comment_degree GROUP BY id ) TO './data/comment.csv' WITH (HEADER 1, DELIMITER ',') "
    ))
  
} 

if (node == "forum" || node == "all") {
  
  cat("computing forum degree\n")
  
  invisible(
  dbExecute(
    con,
    "CREATE VIEW forum_degree AS 
  SELECT forum_containerof as id, count(id) as degree FROM post GROUP BY forum_containerof
  UNION ALL
  SELECT id, count(hasmoderator_person) as degree FROM Forum GROUP BY id
  UNION ALL
  SELECT id, count(hasmember_person) as degree FROM forum_hasmember_person GROUP BY id
  UNION ALL
  SELECT id, count(hastag_tag) as degree FROM forum_hastag_tag GROUP BY id
  "
  )
  )
  
  invisible(
    dbExecute(
      con,
      "COPY ( SELECT id, sum(degree) as degree FROM forum_degree GROUP BY id ) TO './data/forum.csv' WITH (HEADER 1, DELIMITER ',') "
    ))
  
}
