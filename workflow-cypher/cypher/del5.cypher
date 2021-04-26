LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/deletes/Forum_hasMember_Person.csv' AS row FIELDTERMINATOR '|'
WITH toInteger(row.src) AS srcId, toInteger(row.trg) AS trgId
MATCH (:Person {id: srcId})-[hm:HAS_MEMBER]->(:Forum {id: trgId})
DELETE hm
