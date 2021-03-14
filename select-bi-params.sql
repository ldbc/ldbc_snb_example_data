SELECT * FROM Message_TagClasses LIMIT 10 OFFSET 10;
SELECT * FROM Message_creationDays LIMIT 10 OFFSET 10;
SELECT * FROM Country_numCities LIMIT 2;
SELECT * FROM Country_numPersons LIMIT 2;
SELECT * FROM Message_Tags LIMIT 10 OFFSET 10;

-- Q14a
SELECT * FROM CountryPairs_numFriends ORDER BY frequency DESC LIMIT 10;
-- Q14b
SELECT * FROM CountryPairs_numFriends ORDER BY frequency ASC  LIMIT 10;
