LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_likes_Post.csv' AS row FIELDTERMINATOR '|'
MATCH (person:Person {id: toInteger(row.id)}), (post:Post {id: toInteger(row.likes_post)})
CREATE (person)-[:LIKES {creationDate: datetime(row.creationdate)}]->(post);
