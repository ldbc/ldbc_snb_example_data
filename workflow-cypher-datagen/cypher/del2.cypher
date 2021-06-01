LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Person_likes_Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.personId) AS personId,
  toInteger(row.postId) AS postId
MATCH (:Person {id: personId})-[likes:LIKES]->(:Post {id: postId})
DELETE likes
