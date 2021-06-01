LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_knows_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.person1id) AS person1id,
  toInteger(row.person2id) AS person2id
MATCH (person1:Person {id: person1id}), (person2:Person {id: person2id})
CREATE (person1)-[:KNOWS {creationDate: creationDate}]->(person2);
