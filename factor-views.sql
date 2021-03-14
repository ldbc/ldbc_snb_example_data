-- maybe add frequency of messages per day/month/year

-- cleanup

DROP VIEW IF EXISTS Country_numCities;
DROP VIEW IF EXISTS Country_numPersons;
DROP VIEW IF EXISTS Country_numMessages;
DROP VIEW IF EXISTS CountryPairs_numFriends;

DROP VIEW IF EXISTS Message_creationDates;
DROP VIEW IF EXISTS Message_length;
DROP VIEW IF EXISTS Message_Tags;
DROP VIEW IF EXISTS Message_TagClasses;

DROP VIEW IF EXISTS Person_numFriends;

DROP VIEW IF EXISTS Post_languages;

DROP VIEW IF EXISTS TagClass_numTags;

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

CREATE VIEW CountryPairs_numFriends AS
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

CREATE VIEW Message_Tags AS
    SELECT hasTag_Tag AS tag, count(id) AS frequency
    FROM (
        SELECT id, hasTag_Tag FROM Comment_hasTag_Tag
        UNION ALL
        SELECT id, hasTag_Tag FROM Post_hasTag_Tag
    ) tags
    GROUP BY hasTag_Tag
    ORDER BY frequency DESC, tag ASC;

CREATE VIEW Message_TagClasses AS
    SELECT Tag.hasType_TagClass AS tagClass, sum(Message_Tags.frequency) AS frequency
    FROM Message_Tags
    JOIN Tag 
      ON Message_Tags.tag = Tag.id
    GROUP BY tagClass
    ORDER BY frequency DESC, tagClass ASC;

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

CREATE VIEW TagClass_numTags AS
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
SELECT '------------ Message_Tags ----------' AS 'factor table'; SELECT * FROM Message_Tags            LIMIT 10;
SELECT '---------- Message_length ----------' AS 'factor table'; SELECT * FROM Message_length          LIMIT 10;
SELECT '--------- Message_TagClasses -------' AS 'factor table'; SELECT * FROM Message_TagClasses      LIMIT 10;
SELECT '---------- Post_languages ----------' AS 'factor table'; SELECT * FROM Post_languages          LIMIT 10;
SELECT '---------- TagClass_numTags --------' AS 'factor table'; SELECT * FROM TagClass_numTags        LIMIT 10;
SELECT '------ CountryPairs_numFriends -----' AS 'factor table'; SELECT * FROM CountryPairs_numFriends LIMIT 10;
