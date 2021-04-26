// INS7/hasTag
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Comment_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (c:Comment {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (c)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);
