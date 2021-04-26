// INS1/workAt
LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_workAt_Company.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationdate) AS creationDate, toInteger(row.id) AS personId, toInteger(row. workat_company) AS companyId, toInteger(row.workfrom) AS workFrom
MATCH (p:Person {id: personId}), (c:Company {id: companyId})
CREATE (p)-[:WORK_AT {creationDate: creationDate, workFrom: workFrom}]->(c);
