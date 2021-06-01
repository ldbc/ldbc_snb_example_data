LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Comment/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH toInteger(row.id) AS id
MATCH (:Comment {id: id})<-[:REPLY_OF*0..]-(comment:Comment)
DETACH DELETE comment
