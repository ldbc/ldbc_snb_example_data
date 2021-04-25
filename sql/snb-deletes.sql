DELETE FROM Delete_Candidates_Person;
DELETE FROM Delete_Candidates_Person_likes_Post;
DELETE FROM Delete_Candidates_Person_likes_Comment;
DELETE FROM Delete_Candidates_Forum;
DELETE FROM Delete_Candidates_Forum_hasMember_Person;
DELETE FROM Delete_Candidates_Post;
DELETE FROM Delete_Candidates_Comment;
DELETE FROM Delete_Candidates_Person_knows_Person;

COPY Delete_Candidates_Comment                   FROM '${PATHVAR}/Comment.csv'                (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Post                      FROM '${PATHVAR}/Post.csv'                   (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Forum                     FROM '${PATHVAR}/Forum.csv'                  (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Forum_hasMember_Person    FROM '${PATHVAR}/Forum_hasMember_Person.csv' (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Person                    FROM '${PATHVAR}/Person.csv'                 (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Person_likes_Post         FROM '${PATHVAR}/Person_likes_Post.csv'      (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Person_likes_Comment      FROM '${PATHVAR}/Person_likes_Comment.csv'   (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Delete_Candidates_Person_knows_Person       FROM '${PATHVAR}/Person_knows_Person.csv'    (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

-- DEL1
DELETE FROM Person
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_likes_Comment
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_likes_Post
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_workAt_Company
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_studyAt_University
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_knows_Person
WHERE Person1Id IN (SELECT id FROM Delete_Candidates_Person)
   OR Person2Id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Person_hasInterest_Tag
WHERE id IN (SELECT id FROM Delete_Candidates_Person);

DELETE FROM Forum_hasMember_Person
WHERE hasMember_Person IN (SELECT id FROM Delete_Candidates_Person);
-- TODO: cascading deletes
-- hasModerator

-- DEL2
DELETE FROM Person_likes_Post
WHERE concat(id, '->', likes_Post)
  IN (SELECT concat(src, '->', trg) FROM Delete_Candidates_Person_likes_Post);

-- DEL3
DELETE FROM Person_likes_Comment
WHERE concat(id, '->', likes_Comment)
  IN (SELECT concat(src, '->', trg) FROM Delete_Candidates_Person_likes_Comment);

-- DEL4
DELETE FROM Forum
WHERE id IN (SELECT id FROM Delete_Candidates_Forum);

DELETE FROM Forum_hasMember_Person
WHERE id IN (SELECT id FROM Delete_Candidates_Forum);
-- delete posts

-- DEL5
DELETE FROM Forum_hasMember_Person
WHERE concat(id, '->', hasMember_Person)
  IN (SELECT concat(src, '->', trg) FROM Delete_Candidates_Forum_hasMember_Person);

-- DEL6
DELETE FROM Post
WHERE id IN (SELECT id FROM Delete_Candidates_Post);

DELETE FROM Person_likes_Post
WHERE likes_Post IN (SELECT id FROM Delete_Candidates_Person_likes_Post);

DELETE FROM Post_hasTag_Tag
WHERE id IN (SELECT id FROM Delete_Candidates_Post);
-- cascading tree...

-- DEL7
DELETE FROM Comment
WHERE id IN (SELECT id FROM Delete_Candidates_Comment);

DELETE FROM Person_likes_Comment
WHERE likes_Comment IN (SELECT id FROM Delete_Candidates_Person_likes_Comment);

DELETE FROM Comment_hasTag_Tag
WHERE id IN (SELECT id FROM Delete_Candidates_Comment);
-- cascading tree...

-- DEL8
-- DELETE FROM Person_knows_Person
-- WHERE concat(Person1id, '->', Person2Id)
--   IN (SELECT concat(src, '->', trg) FROM Delete_Candidates_Person_knows_Person);

DELETE FROM Person_knows_Person
USING Delete_Candidates_Person_knows_Person
WHERE (Person_knows_Person.Person1Id = Delete_Candidates_Person_knows_Person.src AND Person_knows_Person.Person2Id = Delete_Candidates_Person_knows_Person.trg)
   OR (Person_knows_Person.Person1Id = Delete_Candidates_Person_knows_Person.trg AND Person_knows_Person.Person2Id = Delete_Candidates_Person_knows_Person.src)
;
