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
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person.id;

DELETE FROM Person_likes_Comment
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_likes_Comment.id;

DELETE FROM Person_likes_Post
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_likes_Post.id;

DELETE FROM Person_workAt_Company
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_workAt_Company.id;

DELETE FROM Person_studyAt_University
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_studyAt_University.id;

DELETE FROM Person_knows_Person
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_knows_Person.person1Id
   OR Delete_Candidates_Person.id = Person_knows_Person.person2Id;

DELETE FROM Person_hasInterest_Tag
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Person_hasInterest_Tag.id;

DELETE FROM Forum_hasMember_Person
USING Delete_Candidates_Person
WHERE Delete_Candidates_Person.id = Forum_hasMember_Person.id;

UPDATE Forum
SET hasModerator_Person = NULL
WHERE hasModerator_Person IN (SELECT id FROM Delete_Candidates_Person);

INSERT INTO Delete_Candidates_Forum
SELECT Delete_Candidates_Person.deletionDate AS deletionDate, Forum.id
  FROM Delete_Candidates_Person
  JOIN Person
    ON Person.id = Delete_Candidates_Person.id
  JOIN Forum
    ON Forum.hasModerator_Person = Person.id
-- WHERE Forum.type 
;

-- hasModerator

-- DEL2
DELETE FROM Person_likes_Post
USING Delete_Candidates_Person_likes_Post
WHERE Delete_Candidates_Person_likes_Post.src = Person_likes_Post.id
  AND Delete_Candidates_Person_likes_Post.trg = Person_likes_Post.likes_post;

-- DEL3
DELETE FROM Person_likes_Comment
USING Delete_Candidates_Person_likes_Comment
WHERE Delete_Candidates_Person_likes_Comment.src = Person_likes_Comment.id
  AND Delete_Candidates_Person_likes_Comment.trg = Person_likes_Comment.likes_comment;

-- DEL4
DELETE FROM Forum
USING Delete_Candidates_Forum;

DELETE FROM Forum_hasMember_Person
USING Delete_Candidates_Forum
WHERE Delete_Candidates_Forum.id = Forum_hasMember_Person.id;

-- delete posts

-- DEL5
DELETE FROM Forum_hasMember_Person
USING Delete_Candidates_Forum_hasMember_Person
WHERE Delete_Candidates_Forum_hasMember_Person.src = Forum_hasMember_Person.id
  AND Delete_Candidates_Forum_hasMember_Person.trg = Forum_hasMember_Person.hasMember_Person;

-- DEL6
DELETE FROM Post
USING (
  SELECT id
  FROM Delete_Candidates_Post -- starting from the delete candidate post
  UNION
  SELECT Post.id AS id
  FROM Post, Delete_Candidates_Person, Delete_Candidates_Forum
  WHERE Delete_Candidates_Person.id = Post.hasCreator_Person
     OR Delete_Candidates_Forum.id = Post.forum_ContainerOf
) sub
WHERE sub.id = Post.id
;

DELETE FROM Person_likes_Post
WHERE likes_Post IN (SELECT id FROM Delete_Candidates_Person_likes_Post);

DELETE FROM Post_hasTag_Tag
USING Delete_Candidates_Post;
-- we offload the work of deleting the comments to DEL7

-- DEL7
DELETE FROM Comment
USING (
  WITH RECURSIVE message_thread AS (
      SELECT id
      FROM Delete_Candidates_Comment -- starting from the delete candidate comments
      UNION
      SELECT id
      FROM Delete_Candidates_Post -- starting from the delete candidate post
      UNION
      SELECT Comment.id AS id
      FROM Comment
      JOIN Delete_Candidates_Person
        ON Delete_Candidates_Person.id = Comment.hasCreator_Person
      UNION
      SELECT Post.id AS id
      FROM Post, Delete_Candidates_Person, Delete_Candidates_Forum
      WHERE Delete_Candidates_Person.id = Post.hasCreator_Person
         OR Delete_Candidates_Forum.id = Post.forum_ContainerOf
      UNION
      SELECT comment.id AS id
      FROM message_thread
      JOIN comment
        ON comment.replyof_comment = message_thread.id
        OR comment.replyof_post = message_thread.id
  )
  SELECT id
  FROM message_thread
  ) sub
WHERE sub.id = Comment.id
;

DELETE FROM Person_likes_Comment
USING (
  WITH RECURSIVE message_thread AS (
      SELECT id
      FROM Delete_Candidates_Comment -- starting from the delete candidate comments
      UNION
      SELECT id
      FROM Delete_Candidates_Post -- starting from the delete candidate post
      UNION
      SELECT Comment.id AS id
      FROM Comment
      JOIN Delete_Candidates_Person
        ON Delete_Candidates_Person.id = Comment.hasCreator_Person
      UNION
      SELECT Post.id AS id
      FROM Post, Delete_Candidates_Person, Delete_Candidates_Forum
      WHERE Delete_Candidates_Person.id = Post.hasCreator_Person
         OR Delete_Candidates_Forum.id = Post.forum_ContainerOf
      UNION
      SELECT comment.id AS id
      FROM message_thread
      JOIN comment
        ON comment.replyof_comment = message_thread.id
        OR comment.replyof_post = message_thread.id
  )
  SELECT id
  FROM message_thread
  ) sub
WHERE sub.id = Person_likes_Comment.likes_Comment
;

DELETE FROM Comment_hasTag_Tag
USING (
  WITH RECURSIVE message_thread AS (
      SELECT id
      FROM Delete_Candidates_Comment -- starting from the delete candidate comments
      UNION ALL
      SELECT comment.id AS id
      FROM message_thread
      JOIN comment
        ON comment.replyof_comment = message_thread.id
        OR comment.replyof_post = message_thread.id
  )
  SELECT id
  FROM message_thread
  ) sub
WHERE sub.id = Comment_hasTag_Tag.id
;




-- DEL8
DELETE FROM Person_knows_Person
USING Delete_Candidates_Person_knows_Person
WHERE (Person_knows_Person.Person1Id = Delete_Candidates_Person_knows_Person.src AND Person_knows_Person.Person2Id = Delete_Candidates_Person_knows_Person.trg)
   OR (Person_knows_Person.Person1Id = Delete_Candidates_Person_knows_Person.trg AND Person_knows_Person.Person2Id = Delete_Candidates_Person_knows_Person.src)
;
