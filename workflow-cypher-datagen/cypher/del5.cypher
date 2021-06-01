LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Forum_hasMember_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.forumId) AS forumId,
  toInteger(row.personId) AS personId
MATCH (:Forum {id: forumId})-[hasMember:HAS_MEMBER]->(:Person {id: personId})
DELETE hasMember
