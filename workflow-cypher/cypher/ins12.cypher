// INS4/hasTag
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Forum_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (f:Forum {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (f)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);
