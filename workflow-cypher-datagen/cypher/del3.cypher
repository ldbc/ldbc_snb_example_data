LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Person_likes_Comment/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.personId) AS personId,
  toInteger(row.commentId) AS commentId
MATCH (:Person {id: personId})-[likes:LIKES]->(:Comment {id: commentId})
DELETE likes
