LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_likes_Comment/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.personId) AS personId,
  toInteger(row.commentId) AS commentId
MATCH (person:Person {id: personId}), (comment:Comment {id: commentId})
CREATE (person)-[:LIKES {creationDate: creationDate}]->(comment)
RETURN count(*)
