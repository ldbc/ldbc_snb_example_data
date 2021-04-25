LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Forum.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationDate) AS creationDate, toInteger(row.id) AS id, row.title AS title, toInteger(row.hasmoderator_person) AS personId
MATCH (p:Person {id: personId})
CREATE (f:Forum {creationDate: creationDate, id: id, title: title})-[:HAS_MODERATOR]->(p);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Forum_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (f:Forum {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (f)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);
