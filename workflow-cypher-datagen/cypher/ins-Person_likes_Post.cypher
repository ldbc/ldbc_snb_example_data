LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_likes_Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.personId) AS personId,
  toInteger(row.postId) AS postId
MATCH (person:Person {id: personId}), (post:Post {id: postId})
CREATE (person)-[:LIKES {creationDate: creationDate}]->(post);
