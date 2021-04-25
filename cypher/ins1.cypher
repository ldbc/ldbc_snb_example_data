/*
:param batch: '2011-01-01'
*/

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationDate) AS creationDate, toInteger(row.id) AS id, row.firstName AS firstName, row.lastName AS lastName, row.gender AS gender, date(row.birthday) AS birthday, row.locationIP AS locationIP, row.browserUsed AS browserUsed, row.islocatedin_city AS cityId, split(row.speaks, ';') AS speaks, split(row.email, ';') AS email
MATCH (c:City {id: cityId})
CREATE (p:Person {creationDate: creationDate, id: id, firstName: firstName, lastName: lastName, gender: gender, birthday: birthday, locationIP: locationIP, browserUsed: browserUsed, speaks: speaks, email: email})-[:IS_LOCATED_IN]->(c);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_hasInterest_Tag.csv' AS row FIELDTERMINATOR '|'
MATCH (p:Person {id: toInteger(row.id)}), (t:Tag {id: toInteger(row.hasinterest_tag)})
CREATE (p)-[:HAS_INTEREST {creationDate: datetime(row.creationdate)}]->(t);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_workAt_Company.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationdate) AS creationDate, toInteger(row.id) AS personId, toInteger(row. workat_company) AS companyId, toInteger(row.workfrom) AS workFrom
MATCH (p:Person {id: personId}), (c:Company {id: companyId})
CREATE (p)-[:WORK_AT {creationDate: creationDate, workFrom: workFrom}]->(c);

LOAD CSV WITH HEADERS FROM 'file:///' + $batch + '/inserts/Person_studyAt_University.csv' AS row FIELDTERMINATOR '|'
WITH datetime(row.creationdate) AS creationDate, toInteger(row.id) AS personId, toInteger(row.studyat_university) AS universityId, toInteger(row.classyear) AS classYear
MATCH (p:Person {id: personId}), (u:University {id: universityId})
CREATE (p)-[:STUDY_AT {creationDate: creationDate, classYear: classYear}]->(u);
