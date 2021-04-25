LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Forum.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (forum:Forum {id: id})-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(message:Message)
DETACH DELETE forum, message
