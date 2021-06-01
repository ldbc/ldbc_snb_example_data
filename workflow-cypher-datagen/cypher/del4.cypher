LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Forum/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (forum:Forum {id: id})-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(message:Message)
DETACH DELETE forum, message
