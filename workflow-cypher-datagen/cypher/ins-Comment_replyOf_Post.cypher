LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment_replyOf_Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.CommentId) AS commentId,
  toInteger(row.PostId) AS postId
MATCH (comment:Comment {id: commentId}), (post:Post {id: postId})
CREATE (comment)-[:REPLY_OF {creationDate: creationDate}]->(post)
RETURN count(*)
