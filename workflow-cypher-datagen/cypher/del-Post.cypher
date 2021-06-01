LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (:Post {id: id})<-[:REPLY_OF*0..]-(message:Message) // DEL 6/7
DETACH DELETE message
RETURN count(*)
