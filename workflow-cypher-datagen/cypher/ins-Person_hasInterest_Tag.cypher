LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_hasInterest_Tag/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.personId) AS personId,
  toInteger(row.tagId) AS tagId
MATCH (person:Person {id: personId}), (tag:Tag {id: tagId})
CREATE (person)-[:HAS_INTEREST {creationDate: creationDate}]->(tag)
RETURN count(*)
