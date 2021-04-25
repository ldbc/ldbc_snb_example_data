LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Post.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationDate) AS creationDate, toInteger(row.id) AS id, row.imageFile AS imageFile, row.locationIP AS locationIP, row.browserUsed AS browserUsed, row.language AS language, row.content AS content, toInteger(row.length) AS length, toInteger(row.forum_containerof) AS forumId, toInteger(row.hascreator_person) AS personId, toInteger(row.islocatedin_country) AS countryId
MATCH (f:Forum {id: forumId}), (creator:Person {id: personId}), (country:Country {id: countryId})
CREATE
  (post:Post {creationDate: creationDate, id: id, imageFile: imageFile, locationIP: locationIP, browserUsed: browserUsed, language: language, content: content})<-[:CONTAINER_OF]-(f),
  (post)-[:HAS_CREATOR]->(creator),
  (post)-[:IS_LOCATED_IN]->(country);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Post_hasTag_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (p:Post {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hastag_tag)})
CREATE (p)-[:HAS_TAG {creationDate: datetime(row.creationdate)}]->(t);
