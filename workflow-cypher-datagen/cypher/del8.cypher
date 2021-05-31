LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Person.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.src) AS srcId, toInteger(row.trg) AS trgId
MATCH (:Person {id: srcId})-[k:KNOWS]-(:Person {id: trgId})
DELETE k
