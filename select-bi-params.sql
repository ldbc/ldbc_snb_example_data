-- Q1
COPY (
    SELECT
        strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS 'datetime:DATETIME'
    FROM Message_creationDates
    LIMIT 10
    )
    TO 'parameters/bi-1.csv'
    WITH (HEADER, DELIMITER '|');

-- Q2
COPY (
    SELECT
        Message_creationDays.creationDay AS 'date:DATE',
        Message_TagClasses.tagClassName AS 'tagClass:STRING'
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT * FROM Message_TagClasses   LIMIT 10) Message_TagClasses
    )
    TO 'parameters/bi-2.csv'
    WITH (HEADER, DELIMITER '|');

-- Q3
COPY (
    SELECT
        Message_TagClasses.tagClassName AS 'tagClass:STRING',
        Country_numPersons.name AS 'country:STRING'
    FROM
        (SELECT * FROM Message_TagClasses LIMIT 10) Message_TagClasses,
        (SELECT * FROM Country_numPersons LIMIT  2) Country_numPersons
    )
    TO 'parameters/bi-3.csv'
    WITH (HEADER, DELIMITER '|');

-- Q4
COPY (
    SELECT
        creationDay AS 'date:DATE'
    FROM Message_creationDays
    LIMIT 20
    )
    TO 'parameters/bi-4.csv'
    WITH (HEADER, DELIMITER '|');

-- Q5
COPY (
    SELECT
        tagName AS 'tag:STRING'
    FROM Message_Tags
    LIMIT 10
    )
    TO 'parameters/bi-5.csv'
    WITH (HEADER, DELIMITER '|');

-- Q6
COPY (
    SELECT
        tagName AS 'tag:STRING'
    FROM Message_Tags
    LIMIT 10
    )
    TO 'parameters/bi-6.csv'
    WITH (HEADER, DELIMITER '|');

-- Q7
COPY (
    SELECT
        tagName AS 'tag:STRING'
    FROM Message_Tags
    LIMIT 10
    )
    TO 'parameters/bi-7.csv'
    WITH (HEADER, DELIMITER '|');

-- Q8
COPY (
    SELECT
        Message_Tags.tagName AS 'tag:STRING',
        Message_creationDays.creationDay AS 'date:DATE'
    FROM
        (SELECT * FROM Message_Tags LIMIT 10) Message_Tags,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays
    )
    TO 'parameters/bi-8.csv'
    WITH (HEADER, DELIMITER '|');

-- Q9
-- we add 8-10 days to the startDate to get the endDate
SELECT setseed(0.42);
COPY (
    SELECT
        Message_creationDays.creationDay AS 'startDate:DATE',
        Message_creationDays.creationDay + 8 + CAST(FLOOR(3*RANDOM()) AS INT) AS 'endDate:DATE'
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays
    )
    TO 'parameters/bi-9.csv'
    WITH (HEADER, DELIMITER '|');

-- Q10
-- potential minPathDistance and maxPathDistance values: 1..2, 1..3, 2..2, 2..3
SELECT setseed(0.42);
COPY (
    SELECT
        Person_numFriends.id AS 'personId:ID',
        Country_numPersons.name AS 'country:STRING',
        Message_TagClasses.tagClassName AS 'tagClass:STRING',
        1+CAST(FLOOR(2*RANDOM()) AS INT) AS 'minPathDistance:LONG',
        2+CAST(FLOOR(2*RANDOM()) AS INT) AS 'maxPathDistance:LONG'
    FROM
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends,
        (SELECT * FROM Country_numPersons LIMIT 10) Country_numPersons, -- OFFSET 2
        (SELECT * FROM Message_TagClasses LIMIT 10) Message_TagClasses
    )
    TO 'parameters/bi-10.csv'
    WITH (HEADER, DELIMITER '|');

-- Q11: using Message_creationDays to determine the startDay
COPY (
    SELECT
        country AS 'country:STRING',
        startDate AS 'startDate:DATE'
    FROM
        (SELECT name AS country FROM Country_numPersons LIMIT 10) c, -- OFFSET 2
        (SELECT creationDay AS startDate FROM Message_creationDays LIMIT 10) startDate
    )
    TO 'parameters/bi-11.csv'
    WITH (HEADER, DELIMITER '|');

-- Q12
-- TODO: balance
COPY (
    SELECT
        Message_creationDays.creationDay AS 'date:DATE',
        Message_length.length AS 'lengthThreshold:LONG',
        Post_languages.language AS 'languages:STRING[]' -- should be multiple languages concatenated to a single string
    FROM
        (SELECT creationDay FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT length FROM Message_length LIMIT 10) Message_length, -- OFFSET count/5?
        (SELECT language FROM Post_languages LIMIT 10) Post_languages
    )
    TO 'parameters/bi-12.csv'
    WITH (HEADER, DELIMITER '|');

-- Q13
COPY (
    SELECT
        Country_numPersons.name AS 'country:STRING',
        creationDay AS 'endDate:DATE'
    FROM
        (SELECT * FROM Country_numPersons LIMIT  2) Country_numPersons,
        (SELECT * FROM Message_creationDays ORDER BY creationDay DESC LIMIT 10) Message_creationDays
    )
    TO 'parameters/bi-13.csv'
    WITH (HEADER, DELIMITER '|');

-- Q14
-- Q14a: correlated countries
COPY (SELECT
        country1Name AS 'country1:STRING',
        country2Name AS 'country2:STRING'
    FROM CountryPairs_numFriends
    ORDER BY frequency DESC
    LIMIT 10
    )
    TO 'parameters/bi-14a.csv'
    WITH (HEADER, DELIMITER '|');

-- Q14b: anti-correlated countries
COPY (SELECT
        country1Name AS 'country1:STRING',
        country2Name AS 'country2:STRING'
    FROM CountryPairs_numFriends
    ORDER BY frequency ASC
    LIMIT 10
    )
    TO 'parameters/bi-14b.csv'
    WITH (HEADER, DELIMITER '|');

-- Q15
-- we add 8-10 days to the startDate to get the endDate
SELECT setseed(0.42);
COPY (
    SELECT
        Person_numFriends1.id AS 'person1Id:ID',
        Person_numFriends2.id AS 'person2Id:ID',
        Message_creationDays.creationDay AS 'startDate:DATE',
        Message_creationDays.creationDay + 8 + CAST(FLOOR(3*RANDOM()) AS INT) AS 'endDate:DATE'
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends1,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends2
    WHERE Person_numFriends1.id != Person_numFriends2.id
    )
    TO 'parameters/bi-15.csv'
    WITH (HEADER, DELIMITER '|');

-- Q16
-- set maxKnowsLimit between 3 and 6
SELECT setseed(0.42);
COPY (
    SELECT
        Message_TagsA.tagName AS 'tagA:STRING',
        Message_creationDaysA.creationDay AS 'dateA:DATE',
        Message_TagsB.tagName AS 'tagB:STRING',
        Message_creationDaysB.creationDay AS 'dateB:DATE',
        3 + CAST(FLOOR(4*RANDOM()) AS INT) AS 'maxKnowsLimit:LONG'
    FROM
        (SELECT * FROM Message_Tags LIMIT 10) Message_TagsA,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDaysA,
        (SELECT * FROM Message_Tags LIMIT 10) Message_TagsB,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDaysB
    WHERE Message_TagsA.tagId != Message_TagsB.tagId
      AND Message_creationDaysA.creationDay != Message_creationDaysB.creationDay
    )
    TO 'parameters/bi-16.csv'
    WITH (HEADER, DELIMITER '|');

-- Q17
-- delta is set between 8 and 16 hours
SELECT setseed(0.42);
COPY (
    SELECT
        Message_Tags.tagName AS 'tag:STRING',
        8 + CAST(FLOOR(9*RANDOM()) AS INT) AS 'delta:LONG'
    FROM Message_Tags
    )
    TO 'parameters/bi-17.csv'
    WITH (HEADER, DELIMITER '|');

-- Q18
COPY (
    SELECT
        Person_numFriends.id AS 'person1Id:ID',
        Message_Tags.tagName AS 'tag:STRING'
    FROM
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends,
        (SELECT * FROM Message_Tags LIMIT 10) Message_Tags
    )
    TO 'parameters/bi-18.csv'
    WITH (HEADER, DELIMITER '|');

-- Q19
COPY (
    SELECT
        city1Id AS 'city1Id:ID',
        city2Id AS 'city2Id:ID'
    FROM CityPairs_numFriends
    LIMIT 10)
    TO 'parameters/bi-19.csv'
    WITH (HEADER, DELIMITER '|');

-- Q20
COPY (
    SELECT
        Companies_numEmployees.name AS 'company:STRING',
        Person_numFriends.id AS 'person2Id:ID'
    FROM
        (SELECT * FROM Companies_numEmployees LIMIT 10) Companies_numEmployees,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends
    )
    TO 'parameters/bi-20.csv'
    WITH (HEADER, DELIMITER '|');
