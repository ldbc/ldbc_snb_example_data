LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Forum_hasModerator_Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.forumId) AS forumId,
  toInteger(row.personId) AS personId
MATCH (forum:Forum {id: forumId}), (person:Person {id: personId})
CREATE (forum)-[:HAS_MODERATOR {creationDate: creationDate}]->(person);
