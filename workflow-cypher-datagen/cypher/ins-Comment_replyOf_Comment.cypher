LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment_replyOf_Comment/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.Comment1Id) AS commentId,
  toInteger(row.Comment2Id) AS parentCommentId
MATCH (comment:Comment {id: commentId}), (parentComment:Comment {id: parentCommentId})
CREATE (comment)-[:REPLY_OF {creationDate: creationDate}]->(parentComment)
RETURN count(*)
