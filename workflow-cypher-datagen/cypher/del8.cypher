LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Person_knows_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.person1id) AS person1id,
  toInteger(row.person2id) AS person2id
MATCH (:Person {id: person1id})-[knows:KNOWS]-(:Person {id: person2id})
DELETE knows
