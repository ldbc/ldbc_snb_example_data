LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Post_hasTag_Tag/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.postId) AS postId,
  toInteger(row.tagId) AS tagId
MATCH (post:Post {id: postId}), (tag:Tag {id: tagId})
CREATE (post)-[:HAS_TAG {creationDate: creationDate}]->(tag);
