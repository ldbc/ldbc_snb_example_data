LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Post_isLocatedIn_Country/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.postId) AS postId,
  toInteger(row.countryId) AS countryId
MATCH (post:Post {id: postId}), (country:Country {id: countryId})
CREATE (post)-[:IS_LOCATED_IN {creationDate: creationDate}]->(country)
RETURN count(*)
