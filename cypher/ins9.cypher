// INS1/hasInterest
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_hasInterest_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (p:Person {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hasinterest_tag)})
CREATE (p)-[:HAS_INTEREST {creationDate: datetime(row.creationdate)}]->(t);
