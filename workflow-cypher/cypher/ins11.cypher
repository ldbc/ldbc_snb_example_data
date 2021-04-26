// INS1/studyAt
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_studyAt_University.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationdate) AS creationDate, toInteger(row.id) AS personId, toInteger(row.studyat_university) AS universityId, toInteger(row.classyear) AS classYear
MATCH (p:Person {id: personId}), (u:University {id: universityId})
CREATE (p)-[:STUDY_AT {creationDate: creationDate, classYear: classYear}]->(u);
