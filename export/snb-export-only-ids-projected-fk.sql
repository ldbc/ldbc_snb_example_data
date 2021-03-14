-- csv-only-ids-projected-fk

-- static

-- Organisation

COPY (SELECT id FROM Organisation WHERE type = 'Company')
  TO 'data/csv-only-ids-projected-fk/Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id FROM Organisation WHERE type = 'University')
  TO 'data/csv-only-ids-projected-fk/University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_Country FROM Organisation WHERE type = 'Company')
  TO 'data/csv-only-ids-projected-fk/Company_isLocatedIn_Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_City FROM Organisation WHERE type = 'University')
  TO 'data/csv-only-ids-projected-fk/University_isLocatedIn_City.csv'
  WITH (HEADER, DELIMITER '|');

-- Places

COPY (SELECT id FROM Place WHERE type = 'Continent')
  TO 'data/csv-only-ids-projected-fk/Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id FROM Place WHERE type = 'Country')
  TO 'data/csv-only-ids-projected-fk/Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id FROM Place WHERE type = 'City')
  TO 'data/csv-only-ids-projected-fk/City.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place AS isPartOf_Continent FROM Place WHERE type = 'Country')
  TO 'data/csv-only-ids-projected-fk/Country_isPartOf_Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place AS isPartOf_Country FROM Place WHERE type = 'City')
  TO 'data/csv-only-ids-projected-fk/City_isPartOf_Country.csv'
  WITH (HEADER, DELIMITER '|');

-- Tag

COPY (SELECT id FROM Tag)
  TO 'data/csv-only-ids-projected-fk/Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasType_TagClass FROM Tag)
  TO 'data/csv-only-ids-projected-fk/Tag_hasType_TagClass.csv'
  WITH (HEADER, DELIMITER '|');

-- TagClass

COPY (SELECT id FROM TagClass)
  TO 'data/csv-only-ids-projected-fk/TagClass.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isSubclassOf_TagClass FROM TagClass WHERE isSubclassOf_TagClass IS NOT NULL)
  TO 'data/csv-only-ids-projected-fk/TagClass_isSubclassOf_TagClass.csv'
  WITH (HEADER, DELIMITER '|');

-- dynamic

-- Forum

COPY (SELECT id FROM Forum)
  TO 'data/csv-only-ids-projected-fk/Forum.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasModerator_Person FROM Forum)
  TO 'data/csv-only-ids-projected-fk/Forum_hasModerator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Forum_hasTag_Tag)
  TO 'data/csv-only-ids-projected-fk/Forum_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

-- Comment

COPY (SELECT id FROM Comment)
  TO 'data/csv-only-ids-projected-fk/Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasCreator_Person FROM Comment)
  TO 'data/csv-only-ids-projected-fk/Comment_hasCreator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place FROM Comment)
  TO 'data/csv-only-ids-projected-fk/Comment_isLocatedIn_Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, replyOf_Post FROM Comment WHERE replyOf_Post IS NOT NULL)
  TO 'data/csv-only-ids-projected-fk/Comment_replyOf_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, replyOf_Comment FROM Comment WHERE replyOf_Comment IS NOT NULL)
  TO 'data/csv-only-ids-projected-fk/Comment_replyOf_Comment.csv'
  WITH (HEADER, DELIMITER '|');

-- Post

COPY (SELECT id FROM Post)
  TO 'data/csv-only-ids-projected-fk/Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasCreator_Person FROM Post)
  TO 'data/csv-only-ids-projected-fk/Post_hasCreator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT Forum_containerOf AS forumId, id AS postId FROM Post)
  TO 'data/csv-only-ids-projected-fk/Forum_containerOf_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place FROM Post)
  TO 'data/csv-only-ids-projected-fk/Post_isLocatedIn_Place.csv'
  WITH (HEADER, DELIMITER '|');

-- Person

COPY (SELECT id FROM Person)
  TO 'data/csv-only-ids-projected-fk/Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place FROM Person)
  TO 'data/csv-only-ids-projected-fk/Person_isLocatedIn_Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Comment_hasTag_Tag)
  TO 'data/csv-only-ids-projected-fk/Comment_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasTag_Tag FROM Post_hasTag_Tag)
  TO 'data/csv-only-ids-projected-fk/Post_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasMember_Person FROM Forum_hasMember_Person)
  TO 'data/csv-only-ids-projected-fk/Forum_hasMember_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasInterest_Tag FROM Person_hasInterest_Tag)
  TO 'data/csv-only-ids-projected-fk/Person_hasInterest_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, likes_Comment FROM Person_likes_Comment)
  TO 'data/csv-only-ids-projected-fk/Person_likes_Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, likes_Post FROM Person_likes_Post)
  TO 'data/csv-only-ids-projected-fk/Person_likes_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, studyAt_University FROM Person_studyAt_University)
  TO 'data/csv-only-ids-projected-fk/Person_studyAt_University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, workAt_Company FROM Person_workAt_Company)
  TO 'data/csv-only-ids-projected-fk/Person_workAt_Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT Person1id, Person2id FROM Person_knows_Person)
  TO 'data/csv-only-ids-projected-fk/Person_knows_Person.csv'
  WITH (HEADER, DELIMITER '|');
