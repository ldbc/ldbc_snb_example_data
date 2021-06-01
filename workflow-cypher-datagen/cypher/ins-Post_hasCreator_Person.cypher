LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Post_hasCreator_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.PostId) AS postId,
  toInteger(row.PersonId) AS personId
MATCH (post:Post {id: postId}), (person:Person {id: personId})
CREATE (post)-[:HAS_CREATOR {creationDate: creationDate}]->(person)
RETURN count(*)
