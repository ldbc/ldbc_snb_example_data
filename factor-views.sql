-- maybe add frequency of messages per day/month/year

-- cleanup

DROP VIEW IF EXISTS Country_numCities;
DROP VIEW IF EXISTS Country_numPersons;
DROP VIEW IF EXISTS Country_numMessages;

DROP VIEW IF EXISTS Forum_Countries;

DROP VIEW IF EXISTS Message_creationDates;
DROP VIEW IF EXISTS Message_length;
DROP VIEW IF EXISTS Message_TagClasses;
DROP VIEW IF EXISTS Message_Tags;

DROP VIEW IF EXISTS Person_numFriends;

DROP VIEW IF EXISTS Post_languages;
DROP VIEW IF EXISTS Post_TagClasses;

DROP VIEW IF EXISTS TagClass_numTags;

DROP VIEW IF EXISTS close_Countries; --?


-- define views

-- Country

CREATE VIEW Country_numCities AS
    SELECT isPartOf_Country AS id, count(id) AS numCities
    FROM City
    GROUP BY isPartOf_Country
    ORDER BY numCities DESC, id ASC;

CREATE VIEW Country_numPersons AS
    SELECT isPartOf_Country AS id, count(person.id) AS numPersons
    FROM Person
    JOIN City 
      ON person.isLocatedIn_City = city.id
    GROUP BY isPartOf_Country
    ORDER BY numPersons DESC, id ASC;

CREATE VIEW Country_numMessages AS
    SELECT countryId, count(id) AS frequency
    FROM (
        SELECT id, isLocatedIn_Country AS countryId FROM Comment
        UNION
        SELECT id, isLocatedIn_Country AS countryId FROM Post
    ) numMessages
    GROUP BY countryId
    ORDER BY frequency DESC, countryId ASC;

-- Message

CREATE VIEW Message_creationDates AS
    SELECT creationDate
    FROM (
        SELECT creationDate FROM Comment
        UNION ALL
        SELECT creationDate FROM Post
    ) creationDates
    ORDER BY creationDate ASC;

CREATE VIEW Message_length AS
    SELECT length, count(id) AS frequency
    FROM (
        SELECT id, length FROM Comment
        UNION
        SELECT id, length FROM Post
    ) creationDates
    GROUP BY length
    ORDER BY frequency DESC, length ASC;

-- Post

CREATE VIEW Post_languages AS
    SELECT language, count(id) AS frequency
    FROM Post
    WHERE language IS NOT NULL
    GROUP BY language
    ORDER BY frequency DESC, language ASC;


-- Person

CREATE VIEW Person_numFriends AS
    SELECT person1Id AS id, count(person2Id) AS degree
    FROM Person_knows_Person
    GROUP BY person1Id
    ORDER BY degree DESC, person1Id ASC;



-- CREATE VIEW Message_Tags AS
--     SELECT 

-- show some data from the views

SELECT '------ Message_creationDates -------' AS 'factor table'; SELECT * FROM Message_creationDates LIMIT 10;
SELECT '-------- Country_numMessages -------' AS 'factor table'; SELECT * FROM Country_numMessages LIMIT 10;
SELECT '-------- Country_numPersons --------' AS 'factor table'; SELECT * FROM Country_numPersons LIMIT 10;
SELECT '-------- Country_numCities ---------' AS 'factor table'; SELECT * FROM Country_numCities LIMIT 10;
SELECT '------- Person_numFriends ----------' AS 'factor table'; SELECT * FROM Person_numFriends LIMIT 10;
SELECT '---------- Message_length ----------' AS 'factor table'; SELECT * FROM Message_length LIMIT 10;
SELECT '---------- Post_languages ----------' AS 'factor table'; SELECT * FROM Post_languages LIMIT 10;
