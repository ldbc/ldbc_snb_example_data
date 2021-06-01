LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment_hasCreator_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.CommentId) AS commentId,
  toInteger(row.PersonId) AS personId
MATCH (comment:Comment {id: commentId}), (person:Person {id: personId})
CREATE (comment)-[:HAS_CREATOR {creationDate: creationDate}]->(person)
RETURN count(*)
