LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Person_knows_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.person1Id) AS person1Id,
  toInteger(row.person2Id) AS person2Id
MATCH (:Person {id: person1Id})-[knows:KNOWS]-(:Person {id: person2Id})
DELETE knows
