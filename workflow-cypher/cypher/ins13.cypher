// INS6/hasTag
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Post_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (p:Post {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (p)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);
