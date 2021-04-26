LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Comment.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (:Comment {id: id})<-[:REPLY_OF*0..]-(comment:Comment)
DETACH DELETE comment
