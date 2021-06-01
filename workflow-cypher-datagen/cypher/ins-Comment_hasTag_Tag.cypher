LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment_hasTag_Tag/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.commentId) AS commentId,
  toInteger(row.tagId) AS tagId
MATCH (comment:Comment {id: commentId}), (tag:Tag {id: tagId})
CREATE (comment)-[:HAS_TAG {creationDate: creationDate}]->(tag)
RETURN count(*)
