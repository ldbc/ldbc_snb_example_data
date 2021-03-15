-- Q1
COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate FROM Message_creationDates LIMIT 10)
    TO 'params/bi/q1.csv'
    WITH (HEADER, DELIMITER '|');

-- Q2
COPY (
    SELECT Message_creationDays.creationDay AS date, Message_TagClasses.tagClassName AS tagClass
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT * FROM Message_TagClasses   LIMIT 10) Message_TagClasses
    )
    TO 'params/bi/q2.csv'
    WITH (HEADER, DELIMITER '|');

-- -- Q3
COPY (
    SELECT Message_TagClasses.tagClassName AS tagClass, Country_numPersons.name AS country
    FROM
        (SELECT * FROM Message_TagClasses LIMIT 10) Message_TagClasses,
        (SELECT * FROM Country_numPersons LIMIT  2) Country_numPersons
    )
    TO 'params/bi/q3.csv'
    WITH (HEADER, DELIMITER '|');

-- -- Q4
COPY (SELECT creationDay AS date FROM Message_creationDays LIMIT 20)
    TO 'params/bi/q4.csv'
    WITH (HEADER, DELIMITER '|');

-- Q5
COPY (SELECT tagName AS tag FROM Message_Tags LIMIT 10)
    TO 'params/bi/q5.csv'
    WITH (HEADER, DELIMITER '|');

-- Q6
COPY (SELECT tagName AS tag FROM Message_Tags LIMIT 10)
    TO 'params/bi/q6.csv'
    WITH (HEADER, DELIMITER '|');

-- -- Q7
COPY (SELECT tagName AS tag FROM Message_Tags LIMIT 10)
    TO 'params/bi/q7.csv'
    WITH (HEADER, DELIMITER '|');

-- -- Q8
COPY (
    SELECT Message_Tags.tagName AS tag, Message_creationDays.creationDay AS date
    FROM
        (SELECT * FROM Message_Tags LIMIT 10) Message_Tags,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays
    )
    TO 'params/bi/q8.csv'
    WITH (HEADER, DELIMITER '|');

-- Q9
-- we add 8-10 days to the startDate to get the endDate
SELECT setseed(0.42);
COPY (
    SELECT
        Message_creationDays.creationDay AS startDate,
        Message_creationDays.creationDay + 8 + CAST(FLOOR(3*RANDOM()) AS INT) AS endDate
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays
    )
    TO 'params/bi/q9.csv'
    WITH (HEADER, DELIMITER '|');

-- Q10
-- potential minPathDistance and maxPathDistance values: 1..2, 1..3, 2..2, 2..3
SELECT setseed(0.42);
COPY (
    SELECT
        Person_numFriends.id AS personId,
        Country_numPersons.name AS country,
        Message_TagClasses.tagClassName AS tagClass,
        1+CAST(FLOOR(2*RANDOM()) AS INT) AS minPathDistance,
        2+CAST(FLOOR(2*RANDOM()) AS INT) AS maxPathDistance
    FROM
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends,
        (SELECT * FROM Country_numPersons LIMIT 10) Country_numPersons, -- OFFSET 2
        (SELECT * FROM Message_TagClasses LIMIT 10) Message_TagClasses
    )
    TO 'params/bi/q10.csv'
    WITH (HEADER, DELIMITER '|');

-- Q11: using Message_creationDays to determine the startDay
COPY (
    SELECT country, startDate
    FROM
        (SELECT name AS country FROM Country_numPersons LIMIT 10 OFFSET 2) c,
        (SELECT creationDay AS startDate FROM Message_creationDays LIMIT 10) startDate
    )
    TO 'params/bi/q11.csv'
    WITH (HEADER, DELIMITER '|');

-- Q12
-- TODO: balance
COPY (
    SELECT Message_creationDays.creationDay AS date, Message_length.length AS lengthThreshold, Post_languages.language AS language
    FROM
        (SELECT creationDay FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT length FROM Message_length LIMIT 10) Message_length, -- OFFSET count/5?
        (SELECT language FROM Post_languages LIMIT 10) Post_languages
    )
    TO 'params/bi/q12.csv'
    WITH (HEADER, DELIMITER '|');

-- Q13
COPY (
    SELECT Country_numPersons.name AS country, creationDay AS endDate
    FROM
        (SELECT * FROM Country_numPersons LIMIT  2) Country_numPersons,
        (SELECT * FROM Message_creationDays ORDER BY creationDay DESC LIMIT 10) Message_creationDays
    )
    TO 'params/bi/q13.csv'
    WITH (HEADER, DELIMITER '|');

-- Q14
-- Q14a: correlated countries
COPY (SELECT country1Id, country2Id FROM CountryPairs_numFriends ORDER BY frequency DESC LIMIT 10)
    TO 'params/bi/q14a.csv'
    WITH (HEADER, DELIMITER '|');

-- Q14b: anti-correlated countries
COPY (SELECT country1Id, country2Id FROM CountryPairs_numFriends ORDER BY frequency ASC LIMIT 10)
    TO 'params/bi/q14b.csv'
    WITH (HEADER, DELIMITER '|');

-- Q15
-- we add 8-10 days to the startDate to get the endDate
SELECT setseed(0.42);
COPY (
    SELECT
        Person_numFriends1.id AS person1Id,
        Person_numFriends2.id AS person2Id,
        Message_creationDays.creationDay AS startDate,
        Message_creationDays.creationDay + 8 + CAST(FLOOR(3*RANDOM()) AS INT) AS endDate
    FROM
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDays,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends1,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends2
    WHERE Person_numFriends1.id != Person_numFriends2.id
    )
    TO 'params/bi/q15.csv'
    WITH (HEADER, DELIMITER '|');

-- Q16
-- set maxKnowsLimit between 3 and 6
SELECT setseed(0.42);
COPY (
    SELECT
        Message_TagsA.tagName AS tagA,
        Message_creationDaysA.creationDay AS dateA,
        Message_TagsB.tagName AS tagB,
        Message_creationDaysB.creationDay AS dateB,
        3 + CAST(FLOOR(4*RANDOM()) AS INT) AS maxKnowsLimit
    FROM
        (SELECT * FROM Message_Tags LIMIT 10) Message_TagsA,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDaysA,
        (SELECT * FROM Message_Tags LIMIT 10) Message_TagsB,
        (SELECT * FROM Message_creationDays LIMIT 10) Message_creationDaysB
    WHERE Message_TagsA.tagId != Message_TagsB.tagId
      AND Message_creationDaysA.creationDay != Message_creationDaysB.creationDay
    )
    TO 'params/bi/q16.csv'
    WITH (HEADER, DELIMITER '|');

-- Q17
-- delta is set between 8 and 16 hours
SELECT setseed(0.42);
COPY (
    SELECT
        Message_Tags.tagName AS tag,
        8 + CAST(FLOOR(9*RANDOM()) AS INT) AS delta
    FROM Message_Tags
    )
    TO 'params/bi/q17.csv'
    WITH (HEADER, DELIMITER '|');

-- Q18
COPY (
    SELECT
        Person_numFriends.id AS person1Id,
        Message_Tags.tagName AS tag
    FROM
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends,
        (SELECT * FROM Message_Tags LIMIT 10) Message_Tags
    )
    TO 'params/bi/q18.csv'
    WITH (HEADER, DELIMITER '|');



-- Q19
COPY (SELECT city1Id, city2Id
    FROM CityPairs_numFriends
    LIMIT 10)
    TO 'params/bi/q19.csv'
    WITH (HEADER, DELIMITER '|');

-- Q20
COPY (
    SELECT Companies_numEmployees.id AS company, Person_numFriends.id AS person2Id
    FROM
        (SELECT * FROM Companies_numEmployees LIMIT 10) Companies_numEmployees,
        (SELECT * FROM Person_numFriends LIMIT 10) Person_numFriends
    )
    TO 'params/bi/q20.csv'
    WITH (HEADER, DELIMITER '|');
