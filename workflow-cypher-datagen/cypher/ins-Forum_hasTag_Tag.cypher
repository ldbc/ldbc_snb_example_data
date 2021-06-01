LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Forum_hasTag_Tag/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.ForumId) AS forumId,
  toInteger(row.TagId) AS tagId
MATCH (forum:Forum {id: forumId}), (tag:Tag {id: tagId})
CREATE (forum)-[:HAS_TAG {creationDate: creationDate}]->(tag)
RETURN count(*)
