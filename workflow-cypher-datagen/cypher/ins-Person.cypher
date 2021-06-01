LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.id) AS id,
  row.firstName AS firstName,
  row.lastName AS lastName,
  row.gender AS gender,
  date(row.birthday) AS birthday,
  row.locationIP AS locationIP,
  row.browserUsed AS browserUsed,
  split(row.speaks, ';') AS speaks,
  split(row.email, ';') AS email
CREATE (p:Person {
    creationDate: creationDate,
    id: id,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    birthday: birthday,
    locationIP: locationIP,
    browserUsed: browserUsed,
    speaks: speaks,
    email: email
  })
RETURN count(*)
