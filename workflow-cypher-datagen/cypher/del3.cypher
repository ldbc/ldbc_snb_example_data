LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Person_likes_Comment.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.src) AS srcId, toInteger(row.trg) AS trgId
MATCH (:Person {id: srcId})-[likes:LIKES]->(:Comment {id: trgId})
DELETE likes
