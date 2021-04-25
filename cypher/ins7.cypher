LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Comment.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationDate) AS creationDate, toInteger(row.id) AS id, row.locationIP AS locationIP, row.browserUsed AS browserUsed, row.content AS content, toInteger(row.length) AS length, toInteger(row.replyof_post) + toInteger(row.replyof_comment) + -1 AS parentMessageId, toInteger(row.hascreator_person) AS personId, toInteger(row.islocatedin_country) AS countryId
MATCH (m:Message {id: parentMessageId}), (creator:Person {id: personId}), (country:Country {id: countryId})
CREATE
  (c:Comment {creationDate: creationDate, id: id, locationIP: locationIP, browserUsed: browserUsed, content: content, length: length}),
  (c)-[:HAS_CREATOR]->(creator),
  (c)-[:IS_LOCATED_IN]->(country);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Comment_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (c:Comment {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (c)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);