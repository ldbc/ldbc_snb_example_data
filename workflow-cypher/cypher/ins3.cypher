LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_likes_Comment.csv' AS row FIELDTERMINATOR '|'
MATCH (person:Person {id: toInteger(row.id)}), (c:Comment {id: toInteger(row.likes_comment)})
CREATE (person)-[:LIKES {creationDate: datetime(row.creationdate)}]->(c);
