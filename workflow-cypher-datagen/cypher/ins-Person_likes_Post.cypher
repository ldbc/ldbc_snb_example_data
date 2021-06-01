LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_likes_Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.PersonId) AS personId,
  toInteger(row.PostId) AS postId
MATCH (person:Person {id: personId}), (post:Post {id: postId})
CREATE (person)-[:LIKES {creationDate: creationDate}]->(post)
RETURN count(*)
