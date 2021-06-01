LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_isLocatedIn_City/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.personId) AS personId,
  toInteger(row.cityId) AS cityId
MATCH (person:Person {id: personId}), (city:City {id: personId})
CREATE (person)-[:LIKES {creationDate: creationDate}]->(city);
