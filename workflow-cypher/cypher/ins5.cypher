LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Forum_hasMember_Person.csv' AS row FIELDTERMINATOR '|'
MATCH (c:Forum {id: toInteger(row.id)}), (p:Person {id: toInteger(row.hasmember_person)})
CREATE (c)-[:HAS_MEMBER {creationDate: datetime(row.creationdate)}]->(p);
