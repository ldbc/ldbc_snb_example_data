LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_studyAt_University/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.personId) AS personId,
  toInteger(row.universityId) AS universityId,
  toInteger(row.classYear) AS classYear
MATCH (person:Person {id: personId}), (university:University {id: universityId})
CREATE (person)-[:STUDY_AT {creationDate: creationDate, classYear: classYear}]->(university)
RETURN count(*)
