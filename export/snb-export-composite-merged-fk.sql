-- composite-merged-fk
COPY (SELECT * FROM Organisation)
  TO 'data/csv-composite-merged-fk/initial_snapshot/static/Organisation.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT * FROM Place)
  TO 'data/csv-composite-merged-fk/initial_snapshot/static/Place.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT * FROM Tag)
  TO 'data/csv-composite-merged-fk/initial_snapshot/static/Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT * FROM TagClass)
  TO 'data/csv-composite-merged-fk/initial_snapshot/static/TagClass.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, title, hasModerator_Person FROM Forum)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Forum.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Country, replyOf_Post, replyOf_Comment FROM Comment)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, imageFile, locationIP, browserUsed, language, content, length, hasCreator_Person, Forum_containerOf, isLocatedIn_Country FROM Post)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_City, speaks, email FROM Person)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Comment_hasTag_Tag)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Comment_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Post_hasTag_Tag)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Post_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasMember_Person FROM Forum_hasMember_Person)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Forum_hasMember_Person.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasTag_Tag FROM Forum_hasTag_Tag)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Forum_hasTag_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, hasInterest_Tag FROM Person_hasInterest_Tag)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_hasInterest_Tag.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, likes_Comment FROM Person_likes_Comment)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_likes_Comment.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, likes_Post FROM Person_likes_Post)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_likes_Post.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, studyAt_University, classYear FROM Person_studyAt_University)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_studyAt_University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, id, workAt_Company, workFrom FROM Person_workAt_Company)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_workAt_Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT strftime(creationDate, '%Y-%m-%dT%H:%M:%S.%g+00:00') AS creationDate, Person1id, Person2id FROM Person_knows_Person)
  TO 'data/csv-composite-merged-fk/initial_snapshot/dynamic/Person_knows_Person.csv'
  WITH (HEADER, DELIMITER '|');
