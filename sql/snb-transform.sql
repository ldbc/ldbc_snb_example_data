-- filter data
-- static
INSERT INTO Organisation
  SELECT * FROM Raw_Organisation;

INSERT INTO Place
  SELECT * FROM Raw_Place;

INSERT INTO Tag
  SELECT * FROM Raw_Tag;

INSERT INTO TagClass
  SELECT * FROM Raw_TagClass;

-- static / separate labels
INSERT INTO Company
  SELECT id, name, url, isLocatedIn_Place AS isLocatedIn_Country
  FROM Organisation
  WHERE type = 'Company';

INSERT INTO University
  SELECT id, name, url, isLocatedIn_Place AS isLocatedIn_City
  FROM Organisation
  WHERE type = 'University';

INSERT INTO Continent
  SELECT id, name, url
  FROM Place
  WHERE type = 'Continent';

INSERT INTO Country
  SELECT id, name, url, isPartOf_Place AS isPartOf_Continent
  FROM Place
  WHERE type = 'Country';

INSERT INTO City
  SELECT id, name, url, isPartOf_Place AS isPartOf_Country
  FROM Place
  WHERE type = 'City';

-- dynamic
-- many-to-many-edges
INSERT INTO Comment_hasTag_Tag
  SELECT creationDate, id, hasTag_Tag
  FROM Raw_Comment_hasTag_Tag
;

INSERT INTO Post_hasTag_Tag
  SELECT creationDate, id, hasTag_Tag
  FROM Raw_Post_hasTag_Tag
;

INSERT INTO Forum_hasMember_Person
  SELECT creationDate, id, hasMember_Person
  FROM Raw_Forum_hasMember_Person
;

INSERT INTO Forum_hasTag_Tag
  SELECT creationDate, id, hasTag_Tag
  FROM Raw_Forum_hasTag_Tag
;

INSERT INTO Person_hasInterest_Tag
  SELECT creationDate, id, hasInterest_Tag
  FROM Raw_Person_hasInterest_Tag
;

INSERT INTO Person_likes_Comment
  SELECT creationDate, id, likes_Comment
  FROM Raw_Person_likes_Comment
;

INSERT INTO Person_likes_Post
  SELECT creationDate, id, likes_Post
  FROM Raw_Person_likes_Post
;

INSERT INTO Person_studyAt_University
  SELECT creationDate, id, studyAt_University, classYear
  FROM Raw_Person_studyAt_University
;

INSERT INTO Person_workAt_Company
  SELECT creationDate, id, workAt_Company, workFrom
  FROM Raw_Person_workAt_Company
;

INSERT INTO Person_knows_Person
  SELECT creationDate, Person1id, Person2id
  FROM Raw_Person_knows_Person
;

-- Forums/Messages and their many-to-one edges
INSERT INTO Comment
  SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment
  FROM Raw_Comment
;
INSERT INTO Forum
  SELECT creationDate, id, title, hasModerator_Person
  FROM Raw_Forum
;
INSERT INTO Post
  SELECT creationDate, id, imageFile, locationIP, browserUsed, language, content, length, hasCreator_Person, Forum_containerOf, isLocatedIn_Place
  FROM Raw_Post
;

-- Persons
INSERT INTO Person
  SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_Place, speaks, email
  FROM Raw_Person
;
