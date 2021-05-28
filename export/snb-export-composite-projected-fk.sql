-- composite-projected-fk
COPY (SELECT id, type, name, url FROM Organisation)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Organisation.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place FROM Organisation)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Organisation_isLocatedIn_Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url, type FROM Place)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place FROM Place WHERE isPartOf_Place IS NOT NULL)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Place_isPartOf_Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, hasType_TagClass FROM Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/Tag_hasType_TagClass.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM TagClass)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/TagClass.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isSubclassOf_TagClass FROM TagClass WHERE isSubclassOf_TagClass IS NOT NULL)
  TO 'data/csv-composite-projected-fk/initial_snapshot/static/TagClass_isSubclassOf_TagClass.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, title FROM Forum)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Forum.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasModerator_Person FROM Forum)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Forum_hasModerator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, locationIP, browserUsed, content, length FROM Comment)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasCreator_Person FROM Comment)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment_hasCreator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, isLocatedIn_Country FROM Comment)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment_isLocatedIn_Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, replyOf_Post FROM Comment WHERE replyOf_Post IS NOT NULL)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment_replyOf_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, replyOf_Comment FROM Comment WHERE replyOf_Comment IS NOT NULL)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment_replyOf_Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, imageFile, locationIP, browserUsed, language, content, length FROM Post)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasCreator_Person FROM Post)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Post_hasCreator_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, Forum_containerOf AS forumId, id AS postId FROM Post)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Forum_containerOf_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, isLocatedIn_Country FROM Post)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Post_isLocatedIn_Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, speaks, email FROM Person)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, isLocatedIn_City FROM Person)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_isLocatedIn_City.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Comment_hasTag_Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Comment_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Post_hasTag_Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Post_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasMember_Person FROM Forum_hasMember_Person)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Forum_hasMember_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Forum_hasTag_Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Forum_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasInterest_Tag FROM Person_hasInterest_Tag)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_hasInterest_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, likes_Comment FROM Person_likes_Comment)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_likes_Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, likes_Post FROM Person_likes_Post)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_likes_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, studyAt_University, classYear FROM Person_studyAt_University)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_studyAt_University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, workAt_Company, workFrom FROM Person_workAt_Company)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_workAt_Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, Person1id, Person2id FROM Person_knows_Person)
  TO 'data/csv-composite-projected-fk/initial_snapshot/dynamic/Person_knows_Person.csv'
  WITH (HEADER, DELIMITER '|');
