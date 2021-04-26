LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Post.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (:Post {id: id})<-[:REPLY_OF*0..]-(message:Message)
DETACH DELETE message
