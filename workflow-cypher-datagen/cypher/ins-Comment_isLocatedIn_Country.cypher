LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment_isLocatedIn_Country/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.CommentId) AS commentId,
  toInteger(row.CountryId) AS countryId
MATCH (comment:Comment {id: commentId}), (country:Country {id: countryId})
CREATE (comment)-[:IS_LOCATED_IN {creationDate: creationDate}]->(country)
RETURN count(*)
