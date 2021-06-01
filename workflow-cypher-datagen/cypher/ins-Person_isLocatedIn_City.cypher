LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_isLocatedIn_City/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.PersonId) AS personId,
  toInteger(row.CityId) AS cityId
MATCH (person:Person {id: personId}), (city:City {id: cityId})
CREATE (person)-[:LIKES {creationDate: creationDate}]->(city)
RETURN count(*)
