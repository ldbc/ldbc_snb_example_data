-- csv-only-ids-merged-fk

-- static

-- Organisation

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_Country FROM Organisation WHERE type = 'Company')
  TO 'data/csv-only-ids-merged-fk/Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_City FROM Organisation WHERE type = 'University')
  TO 'data/csv-only-ids-merged-fk/University.csv'
  WITH (HEADER, DELIMITER '|');

-- Place

COPY (SELECT id FROM Place WHERE type = 'Continent')
  TO 'data/csv-only-ids-merged-fk/Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place AS isPartOf_Continent FROM Place WHERE type = 'Country')
  TO 'data/csv-only-ids-merged-fk/Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place AS isPartOf_Country FROM Place WHERE type = 'City')
  TO 'data/csv-only-ids-merged-fk/City.csv'
  WITH (HEADER, DELIMITER '|');

-- Tag

COPY (SELECT id, hasType_TagClass FROM Tag)
  TO 'data/csv-only-ids-merged-fk/Tag.csv'
  WITH (HEADER, DELIMITER '|');

-- TagClass

COPY (SELECT id, isSubclassOf_TagClass FROM TagClass)
  TO 'data/csv-only-ids-merged-fk/TagClass.csv'
  WITH (HEADER, DELIMITER '|');

-- dynamic

COPY (SELECT id, hasModerator_Person FROM Forum)
  TO 'data/csv-only-ids-merged-fk/Forum.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasCreator_Person, isLocatedIn_Country, replyOf_Post, replyOf_Comment FROM Comment)
  TO 'data/csv-only-ids-merged-fk/Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasCreator_Person, Forum_containerOf, isLocatedIn_Country FROM Post)
  TO 'data/csv-only-ids-merged-fk/Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_City FROM Person)
  TO 'data/csv-only-ids-merged-fk/Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Comment_hasTag_Tag)
  TO 'data/csv-only-ids-merged-fk/Comment_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Post_hasTag_Tag)
  TO 'data/csv-only-ids-merged-fk/Post_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasMember_Person FROM Forum_hasMember_Person)
  TO 'data/csv-only-ids-merged-fk/Forum_hasMember_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Forum_hasTag_Tag)
  TO 'data/csv-only-ids-merged-fk/Forum_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasInterest_Tag FROM Person_hasInterest_Tag)
  TO 'data/csv-only-ids-merged-fk/Person_hasInterest_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, likes_Comment FROM Person_likes_Comment)
  TO 'data/csv-only-ids-merged-fk/Person_likes_Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, likes_Post FROM Person_likes_Post)
  TO 'data/csv-only-ids-merged-fk/Person_likes_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, studyAt_University FROM Person_studyAt_University)
  TO 'data/csv-only-ids-merged-fk/Person_studyAt_University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, workAt_Company FROM Person_workAt_Company)
  TO 'data/csv-only-ids-merged-fk/Person_workAt_Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT Person1id, Person2id FROM Person_knows_Person)
  TO 'data/csv-only-ids-merged-fk/Person_knows_Person.csv'
  WITH (HEADER, DELIMITER '|');
