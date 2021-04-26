LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Comment.csv' AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationdate) AS creationDate,
  toInteger(row.id) AS id,
  row.locationip AS locationIP,
  row.browserused AS browserUsed,
  row.content AS content,
  toInteger(row.length) AS length,
  toInteger(row.replyof_post) + toInteger(row.replyof_comment) + -1 AS parentMessageId,
  toInteger(row.hascreator_person) AS personId,
  toInteger(row.islocatedin_country) AS countryId
MATCH (m:Message {id: parentMessageId}), (creator:Person {id: personId}), (country:Country {id: countryId})
CREATE
  (c:Comment:Message {creationDate: creationDate, id: id, locationIP: locationIP, browserUsed: browserUsed, content: content, length: length}),
  (c)-[:HAS_CREATOR]->(creator),
  (c)-[:IS_LOCATED_IN]->(country);
