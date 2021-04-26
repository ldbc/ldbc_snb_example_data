LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person.csv' AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationdate) AS creationDate,
  toInteger(row.id) AS id,
  row.firstname AS firstName,
  row.lastname AS lastName,
  row.gender AS gender,
  date(row.birthday) AS birthday,
  row.locationip AS locationIP,
  row.browserused AS browserUsed,
  toInteger(row.islocatedin_city) AS cityId,
  split(row.speaks, ';') AS speaks,
  split(row.email, ';') AS email
MATCH (c:City {id: cityId})
CREATE (p:Person {creationDate: creationDate, id: id, firstName: firstName, lastName: lastName, gender: gender, birthday: birthday, locationIP: locationIP, browserUsed: browserUsed, speaks: speaks, email: email})-[:IS_LOCATED_IN]->(c);
