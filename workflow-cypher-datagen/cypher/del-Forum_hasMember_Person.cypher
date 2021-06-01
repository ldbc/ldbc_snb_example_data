LOAD CSV WITH HEADERS FROM 'file:///deletes/dynamic/Forum_hasMember_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  toInteger(row.ForumId) AS forumId,
  toInteger(row.PersonId) AS personId
MATCH (:Forum {id: forumId})-[hasMember:HAS_MEMBER]->(:Person {id: personId})
DELETE hasMember
RETURN count(*)
