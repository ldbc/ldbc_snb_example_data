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
  invisible(dbExecute(con, "DROP VIEW IF EXISTS person_degree"))
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

} else if (node == "post" || node == "all") {
  
  cat("computing post degree\n")
  
} else if (node == "comment" || node == "all") {
  
  cat("computing comment degree\n")
  
} else if (node == "forum" || node == "all") {
  
  cat("computing forum degree\n")
  
}
