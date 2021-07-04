-- maybe add frequency of messages per day/month/year

-- cleanup

DROP TABLE IF EXISTS CityPairs_numFriends;
DROP TABLE IF EXISTS Companies_numEmployees;
DROP TABLE IF EXISTS Country_numMessages;
DROP TABLE IF EXISTS Country_numPersons;
DROP TABLE IF EXISTS CountryPairs_numFriends;
DROP TABLE IF EXISTS Message_creationDates; -- datetimes
DROP TABLE IF EXISTS Message_creationDays;  -- dates
DROP TABLE IF EXISTS Message_length;
DROP TABLE IF EXISTS Message_TagClasses;
DROP TABLE IF EXISTS Message_Tags;
DROP TABLE IF EXISTS Person_numFriends;
DROP TABLE IF EXISTS Post_languages;
DROP TABLE IF EXISTS TagClass_numTags;

CREATE TABLE CityPairs_numFriends(city1Id BIGINT, city2Id BIGINT, city1Name VARCHAR, city2Name VARCHAR, frequency INT);
CREATE TABLE Companies_numEmployees(id BIGINT, name VARCHAR, frequency INT);
CREATE TABLE Country_numMessages(id BIGINT, frequency INT);
CREATE TABLE Country_numPersons(id BIGINT, name VARCHAR, numPersons INT);
CREATE TABLE CountryPairs_numFriends(country1Id BIGINT, country2Id BIGINT, country1Name VARCHAR, country2Name VARCHAR, frequency INT);
CREATE TABLE Message_creationDates(creationDate DATETIME);
CREATE TABLE Message_creationDays(creationDay DATE);
CREATE TABLE Message_length(length INT, frequency INT);
CREATE TABLE Message_TagClasses(tagClassId BIGINT, tagClassName VARCHAR, frequency INT);
CREATE TABLE Message_Tags(tagId BIGINT, tagName VARCHAR, frequency INT);
CREATE TABLE Person_numFriends(id BIGINT, numFriends INT);
CREATE TABLE Post_languages(language VARCHAR, frequency INT);
CREATE TABLE TagClass_numTags(id BIGINT, name VARCHAR, frequency INT);

-- define views

-- Country

INSERT INTO Country_numPersons
    SELECT Country.id AS id, Country.name AS name, count(Person.id) AS numPersons
    FROM Person
    JOIN City
      ON Person.isLocatedIn_City = City.id
    JOIN Country
      ON City.isPartOf_Country = Country.id
    GROUP BY Country.id, Country.name
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

INSERT INTO CityPairs_numFriends
    SELECT
        City1.id AS city1Id,
        City2.id AS city2Id,
        City1.name AS city1Name,
        City2.name AS city2Name,
        count(*) AS frequency
    FROM Person_knows_Person
    JOIN Person Person1
      ON Person1.id = Person_knows_Person.Person1Id
    JOIN City City1
      ON City1.id = Person1.isLocatedIn_City
    JOIN Person Person2
      ON Person2.id = Person_knows_Person.Person2Id
    JOIN City City2
      ON City2.id = Person2.isLocatedIn_City
    WHERE City1.id < City2.id
    GROUP BY city1Id, city2Id, city1Name, city2Name
    ORDER BY frequency DESC, city1Id ASC, city2Id ASC;

INSERT INTO CountryPairs_numFriends
    SELECT
        Country1.id AS country1Id,
        Country2.id AS country2Id,
        Country1.name AS country1Name,
        Country2.name AS country2Name,
        count(*) AS frequency
    FROM Person_knows_Person
    JOIN Person Person1
      ON Person1.id = Person_knows_Person.Person1Id
    JOIN City City1
      ON Person1.isLocatedIn_City = City1.id
    JOIN Country Country1
      ON City1.isPartOf_Country = Country1.id
    JOIN Person Person2
      ON Person2.id = Person_knows_Person.Person2Id
    JOIN City City2
      ON Person2.isLocatedIn_City = City2.id
    JOIN Country Country2
      ON City2.isPartOf_Country = Country2.id
    WHERE Country1.id < Country2.id
    GROUP BY country1Id, country2Id, country1Name, country2Name
    ORDER BY frequency DESC, country1Id ASC, country2Id ASC;

-- Message

INSERT INTO Message_creationDates
    SELECT DISTINCT creationDate
    FROM (
        SELECT creationDate FROM Comment
        UNION ALL
        SELECT creationDate FROM Post
    ) creationDates
    ORDER BY creationDate DESC;

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
    SELECT Tag.id AS tagId, Tag.name AS tagName, count(Message_hasTag_Tag.id) AS frequency
    FROM (
        SELECT id, hasTag_Tag FROM Comment_hasTag_Tag
        UNION ALL
        SELECT id, hasTag_Tag FROM Post_hasTag_Tag
    ) Message_hasTag_Tag
    JOIN Tag
      ON Message_hasTag_Tag.hasTag_Tag = Tag.id
    GROUP BY tagId, tagName
    ORDER BY frequency DESC, tagId ASC;

INSERT INTO Message_TagClasses
    SELECT TagClass.id AS tagClassId, TagClass.name AS tagClassName, sum(Message_Tags.frequency) AS frequency
    FROM Message_Tags
    JOIN Tag
      ON Message_Tags.tagId = Tag.id
    JOIN TagClass
      ON Tag.hasType_TagClass = TagClass.id
    GROUP BY tagClassId, tagClassName
    ORDER BY frequency DESC, tagClassId ASC;

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
    SELECT TagClass.id AS id, TagClass.name AS name, count(Tag.id) AS frequency
    FROM Tag
    JOIN TagClass
      ON Tag.hasType_TagClass = TagClass.id
    GROUP BY TagClass.id, TagClass.name
    ORDER BY frequency DESC, TagClass.id ASC;

-- Companies

INSERT INTO Companies_numEmployees
    SELECT Company.id AS id, Company.name AS name, count(Person_workAt_Company.id) AS numEmployees
    FROM Company
    JOIN Person_workAt_Company
      ON Person_workAt_Company.workAt_Company = Company.id
    GROUP BY Company.id, Company.name
    ORDER BY numEmployees DESC, Company.id ASC;

-- show some data from the views

.print '---> Companies_numEmployees <----'; SELECT * FROM Companies_numEmployees  LIMIT 10;
.print '---> Country_numMessages <-------'; SELECT * FROM Country_numMessages     LIMIT 10;
.print '---> Country_numPersons <--------'; SELECT * FROM Country_numPersons      LIMIT 10;
.print '---> CountryPairs_numFriends <---'; SELECT * FROM CountryPairs_numFriends LIMIT 10;
.print '---> CountryPairs_numFriends <---'; SELECT * FROM CountryPairs_numFriends LIMIT 10;
.print '---> Message_creationDates <-----'; SELECT * FROM Message_creationDates   LIMIT 10;
.print '---> Message_creationDays <------'; SELECT * FROM Message_creationDays    LIMIT 10;
.print '---> Message_length <------------'; SELECT * FROM Message_length          LIMIT 10;
.print '---> Message_TagClasses <--------'; SELECT * FROM Message_TagClasses      LIMIT 10;
.print '---> Message_Tags <--------------'; SELECT * FROM Message_Tags            LIMIT 10;
.print '---> Person_numFriends <---------'; SELECT * FROM Person_numFriends       LIMIT 10;
.print '---> Post_languages <------------'; SELECT * FROM Post_languages          LIMIT 10;
.print '---> TagClass_numTags <----------'; SELECT * FROM TagClass_numTags        LIMIT 10;
