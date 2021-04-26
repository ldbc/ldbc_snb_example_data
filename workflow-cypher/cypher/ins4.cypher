LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Forum.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationdate) AS creationDate, toInteger(row.id) AS id, row.title AS title, toInteger(row.hasmoderator_person) AS personId
MATCH (p:Person {id: personId})
CREATE (f:Forum {creationDate: creationDate, id: id, title: title})-[:HAS_MODERATOR]->(p);
