LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Forum_containerOf_Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.ForumId) AS forumId,
  toInteger(row.PostId) AS postId
MATCH (forum:Forum {id: forumId}), (post:Post {id: postId})
CREATE (forum)-[:CONTAINER_OF {creationDate: creationDate}]->(post)
RETURN count(*)
