LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_knows_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.person1Id) AS person1Id,
  toInteger(row.person2Id) AS person2Id
MATCH (person1:Person {id: person1Id}), (person2:Person {id: person2Id})
CREATE (person1)-[:KNOWS {creationDate: creationDate}]->(person2)
RETURN count(*)
