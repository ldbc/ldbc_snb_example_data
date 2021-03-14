-- maybe add frequency of messages per day/month/year

-- cleanup

DROP TABLE IF EXISTS Country_numCities;
DROP TABLE IF EXISTS Country_numPersons;
DROP TABLE IF EXISTS Country_numMessages;
DROP TABLE IF EXISTS CountryPairs_numFriends;
DROP TABLE IF EXISTS Message_creationDates;
DROP TABLE IF EXISTS Message_creationDays;
DROP TABLE IF EXISTS Message_length;
DROP TABLE IF EXISTS Message_Tags;
DROP TABLE IF EXISTS Message_TagClasses;
DROP TABLE IF EXISTS Person_numFriends;
DROP TABLE IF EXISTS Post_languages;
DROP TABLE IF EXISTS TagClass_numTags;

CREATE TABLE Country_numCities(id BIGINT, numCities INT);
CREATE TABLE Country_numPersons(id BIGINT, numPersons INT);
CREATE TABLE Country_numMessages(countryId BIGINT, frequency INT);
CREATE TABLE CountryPairs_numFriends(country1Id BIGINT, country2Id BIGINT, frequency INT);
CREATE TABLE Message_creationDates(creationDate DATETIME);
CREATE TABLE Message_creationDays(creationDay DATE);
CREATE TABLE Message_length(length INT, frequency INT);
CREATE TABLE Message_Tags(tag BIGINT, frequency INT);
CREATE TABLE Message_TagClasses(tagClass BIGINT, frequency INT);
CREATE TABLE Person_numFriends(id BIGINT, numFriends INT);
CREATE TABLE Post_languages(language VARCHAR, frequency INT);
CREATE TABLE TagClass_numTags(tagClass BIGINT, frequency INT);

-- define views

-- Country

INSERT INTO Country_numCities
    SELECT isPartOf_Country AS id, count(id) AS numCities
    FROM City
    GROUP BY isPartOf_Country
    ORDER BY numCities DESC, id ASC;

INSERT INTO Country_numPersons
    SELECT isPartOf_Country AS id, count(person.id) AS numPersons
    FROM Person
    JOIN City
      ON person.isLocatedIn_City = city.id
    GROUP BY isPartOf_Country
    ORDER BY numPersons DESC, id ASC;

INSERT INTO Country_numMessages
    SELECT countryId, count(id) AS frequency
    FROM (
        SELECT id, isLocatedIn_Country AS countryId FROM Comment
        UNION
        SELECT id, isLocatedIn_Country AS countryId FROM Post
    ) numMessages
    GROUP BY countryId
    ORDER BY frequency DESC, countryId ASC;

INSERT INTO CountryPairs_numFriends
    SELECT
        City1.isPartOf_Country AS country1Id,
        City2.isPartOf_Country AS country2Id,
        count(*) AS frequency
    FROM Person_knows_Person
    JOIN Person Person1
      ON Person1.id = Person_knows_Person.Person1Id
    JOIN City City1
      ON Person1.isLocatedIn_City = City1.id
    JOIN Person Person2
      ON Person2.id = Person_knows_Person.Person2Id
    JOIN City City2
      ON Person2.isLocatedIn_City = City2.id
    WHERE City1.isPartOf_Country < City2.isPartOf_Country
    GROUP BY country1Id, country2Id
    ORDER BY frequency DESC, country1Id ASC, country2Id ASC;

-- Message

INSERT INTO Message_creationDates
    SELECT DISTINCT creationDate
    FROM (
        SELECT creationDate FROM Comment
        UNION ALL
        SELECT creationDate FROM Post
    ) creationDates
    ORDER BY creationDate ASC;

INSERT INTO Message_creationDays
    SELECT DISTINCT creationDate::date AS creationDay
    FROM Message_creationDates
    ORDER BY creationDay ASC;

INSERT INTO Message_length
    SELECT length, count(id) AS frequency
    FROM (
        SELECT id, length FROM Comment
        UNION
        SELECT id, length FROM Post
    ) creationDates
    GROUP BY length
    ORDER BY frequency DESC, length ASC;

INSERT INTO Message_Tags
    SELECT hasTag_Tag AS tag, count(id) AS frequency
    FROM (
        SELECT id, hasTag_Tag FROM Comment_hasTag_Tag
        UNION ALL
        SELECT id, hasTag_Tag FROM Post_hasTag_Tag
    ) tags
    GROUP BY hasTag_Tag
    ORDER BY frequency DESC, tag ASC;

INSERT INTO Message_TagClasses
    SELECT Tag.hasType_TagClass AS tagClass, sum(Message_Tags.frequency) AS frequency
    FROM Message_Tags
    JOIN Tag 
      ON Message_Tags.tag = Tag.id
    GROUP BY tagClass
    ORDER BY frequency DESC, tagClass ASC;

-- Person

INSERT INTO Person_numFriends
    SELECT person1Id AS id, count(person2Id) AS numFriends
    FROM Person_knows_Person
    GROUP BY person1Id
    ORDER BY numFriends DESC, person1Id ASC;

-- Post

INSERT INTO Post_languages
    SELECT language, count(id) AS frequency
    FROM Post
    WHERE language IS NOT NULL
    GROUP BY language
    ORDER BY frequency DESC, language ASC;

-- TagClass

INSERT INTO TagClass_numTags
    SELECT hasType_TagClass AS tagClass, count(id) AS frequency
    FROM Tag
    GROUP BY tagClass
    ORDER BY frequency DESC, tagClass ASC;

-- show some data from the views

SELECT '-------- Country_numMessages -------' AS 'factor table'; SELECT * FROM Country_numMessages     LIMIT 10;
SELECT '-------- Country_numPersons --------' AS 'factor table'; SELECT * FROM Country_numPersons      LIMIT 10;
SELECT '-------- Country_numCities ---------' AS 'factor table'; SELECT * FROM Country_numCities       LIMIT 10;
SELECT '------- Person_numFriends ----------' AS 'factor table'; SELECT * FROM Person_numFriends       LIMIT 10;
SELECT '------ Message_creationDates -------' AS 'factor table'; SELECT * FROM Message_creationDates   LIMIT 10;
SELECT '------- Message_creationDays -------' AS 'factor table'; SELECT * FROM Message_creationDays    LIMIT 10;
SELECT '------------ Message_Tags ----------' AS 'factor table'; SELECT * FROM Message_Tags            LIMIT 10;
SELECT '---------- Message_length ----------' AS 'factor table'; SELECT * FROM Message_length          LIMIT 10;
SELECT '--------- Message_TagClasses -------' AS 'factor table'; SELECT * FROM Message_TagClasses      LIMIT 10;
SELECT '---------- Post_languages ----------' AS 'factor table'; SELECT * FROM Post_languages          LIMIT 10;
SELECT '---------- TagClass_numTags --------' AS 'factor table'; SELECT * FROM TagClass_numTags        LIMIT 10;
SELECT '------ CountryPairs_numFriends -----' AS 'factor table'; SELECT * FROM CountryPairs_numFriends LIMIT 10;
