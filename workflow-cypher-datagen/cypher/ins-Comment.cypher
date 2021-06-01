LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Comment/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.id) AS id,
  row.locationIP AS locationIP,
  row.browserUsed AS browserUsed,
  row.content AS content,
  toInteger(row.length) AS length
CREATE (c:Comment:Message {
    creationDate: creationDate,
    id: id,
    locationIP: locationIP,
    browserUsed: browserUsed,
    content: content,
    length: length
  })
RETURN count(*)
