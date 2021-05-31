LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_knows_Person.csv' AS row FIELDTERMINATOR '|'
MATCH (person1:Person {id: toInteger(row.person1id)}), (person2:Person {id: toInteger(row.person2id)})
CREATE (person1)-[:KNOWS {creationDate: datetime(row.creationdate)}]->(person2);
