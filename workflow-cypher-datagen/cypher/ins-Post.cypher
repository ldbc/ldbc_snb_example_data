LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Post/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.id) AS id,
  row.imagefile AS imageFile,
  row.locationip AS locationIP,
  row.browserused AS browserUsed,
  row.language AS language,
  row.content AS content,
  toInteger(row.length) AS length
CREATE (post:Post:Message {
    creationDate: creationDate,
    id: id,
    imageFile: imageFile,
    locationIP: locationIP,
    browserUsed: browserUsed,
    language: language,
    content: content
  });
