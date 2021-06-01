LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Forum/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.id) AS id,
  row.title AS title
CREATE (f:Forum {
    creationDate: creationDate,
    id: id,
    title: title
  })
RETURN count(*);
