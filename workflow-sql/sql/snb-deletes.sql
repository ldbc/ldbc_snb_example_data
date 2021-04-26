DELETE FROM Person_Delete_candidates;
DELETE FROM Person_likes_Post_Delete_candidates;
DELETE FROM Person_likes_Comment_Delete_candidates;
DELETE FROM Forum_Delete_candidates;
DELETE FROM Forum_hasMember_Person_Delete_candidates;
DELETE FROM Post_Delete_candidates;
DELETE FROM Comment_Delete_candidates;
DELETE FROM Person_knows_Person_Delete_candidates;

COPY Comment_Delete_candidates                   FROM '${PATHVAR}/Comment.csv'                (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Post_Delete_candidates                      FROM '${PATHVAR}/Post.csv'                   (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Forum_Delete_candidates                     FROM '${PATHVAR}/Forum.csv'                  (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Forum_hasMember_Person_Delete_candidates    FROM '${PATHVAR}/Forum_hasMember_Person.csv' (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_Delete_candidates                    FROM '${PATHVAR}/Person.csv'                 (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_likes_Post_Delete_candidates         FROM '${PATHVAR}/Person_likes_Post.csv'      (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_likes_Comment_Delete_candidates      FROM '${PATHVAR}/Person_likes_Comment.csv'   (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_knows_Person_Delete_candidates       FROM '${PATHVAR}/Person_knows_Person.csv'    (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

-- DEL1
DELETE FROM Person
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person.id;

DELETE FROM Person_likes_Comment
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_likes_Comment.id;

DELETE FROM Person_likes_Post
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_likes_Post.id;

DELETE FROM Person_workAt_Company
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_workAt_Company.id;

DELETE FROM Person_studyAt_University
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_studyAt_University.id;

DELETE FROM Person_knows_Person
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_knows_Person.person1Id
   OR Person_Delete_candidates.id = Person_knows_Person.person2Id;

DELETE FROM Person_hasInterest_Tag
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Person_hasInterest_Tag.id;

DELETE FROM Forum_hasMember_Person
USING Person_Delete_candidates
WHERE Person_Delete_candidates.id = Forum_hasMember_Person.id;

UPDATE Forum
SET hasModerator_Person = NULL
WHERE hasModerator_Person IN (SELECT id FROM Person_Delete_candidates);

INSERT INTO Forum_Delete_candidates
SELECT Person_Delete_candidates.deletionDate AS deletionDate, Forum.id
  FROM Person_Delete_candidates
  JOIN Person
    ON Person.id = Person_Delete_candidates.id
  JOIN Forum
    ON Forum.hasModerator_Person = Person.id
 WHERE Forum.title LIKE 'Album %'
    OR Forum.title LIKE 'Wall %';
;

-- DEL2
DELETE FROM Person_likes_Post
USING Person_likes_Post_Delete_candidates
WHERE Person_likes_Post_Delete_candidates.src = Person_likes_Post.id
  AND Person_likes_Post_Delete_candidates.trg = Person_likes_Post.likes_post;

-- DEL3
DELETE FROM Person_likes_Comment
USING Person_likes_Comment_Delete_candidates
WHERE Person_likes_Comment_Delete_candidates.src = Person_likes_Comment.id
  AND Person_likes_Comment_Delete_candidates.trg = Person_likes_Comment.likes_comment;

-- DEL4
DELETE FROM Forum
USING Forum_Delete_candidates;

DELETE FROM Forum_hasMember_Person
USING Forum_Delete_candidates
WHERE Forum_Delete_candidates.id = Forum_hasMember_Person.id;

-- DEL5
DELETE FROM Forum_hasMember_Person
USING Forum_hasMember_Person_Delete_candidates
WHERE Forum_hasMember_Person_Delete_candidates.src = Forum_hasMember_Person.id
  AND Forum_hasMember_Person_Delete_candidates.trg = Forum_hasMember_Person.hasMember_Person;

-- DEL6
DELETE FROM Post
USING (
  SELECT id
  FROM Post_Delete_candidates -- starting from the delete candidate post
  UNION
  SELECT Post.id AS id
  FROM Post, Person_Delete_candidates, Forum_Delete_candidates
  WHERE Person_Delete_candidates.id = Post.hasCreator_Person
     OR Forum_Delete_candidates.id = Post.forum_ContainerOf
) sub
WHERE sub.id = Post.id
;

DELETE FROM Person_likes_Post
WHERE likes_Post IN (SELECT id FROM Person_likes_Post_Delete_candidates);

DELETE FROM Post_hasTag_Tag
USING Post_Delete_candidates;
-- we offload the work of deleting the comments to DEL7

-- DEL7
DELETE FROM Comment
USING (
  WITH RECURSIVE message_thread AS (
      SELECT id
      FROM Comment_Delete_candidates -- starting from the delete candidate comments
      UNION
      SELECT id
      FROM Post_Delete_candidates -- starting from the delete candidate post
      UNION
      SELECT Comment.id AS id
      FROM Comment
      JOIN Person_Delete_candidates
        ON Person_Delete_candidates.id = Comment.hasCreator_Person
      UNION
      SELECT Post.id AS id
      FROM Post, Person_Delete_candidates, Forum_Delete_candidates
      WHERE Person_Delete_candidates.id = Post.hasCreator_Person
         OR Forum_Delete_candidates.id = Post.forum_ContainerOf
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
      FROM Comment_Delete_candidates -- starting from the delete candidate comments
      UNION
      SELECT id
      FROM Post_Delete_candidates -- starting from the delete candidate post
      UNION
      SELECT Comment.id AS id
      FROM Comment
      JOIN Person_Delete_candidates
        ON Person_Delete_candidates.id = Comment.hasCreator_Person
      UNION
      SELECT Post.id AS id
      FROM Post, Person_Delete_candidates, Forum_Delete_candidates
      WHERE Person_Delete_candidates.id = Post.hasCreator_Person
         OR Forum_Delete_candidates.id = Post.forum_ContainerOf
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
      FROM Comment_Delete_candidates -- starting from the delete candidate comments
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
USING Person_knows_Person_Delete_candidates
WHERE (Person_knows_Person.Person1Id = Person_knows_Person_Delete_candidates.src AND Person_knows_Person.Person2Id = Person_knows_Person_Delete_candidates.trg)
   OR (Person_knows_Person.Person1Id = Person_knows_Person_Delete_candidates.trg AND Person_knows_Person.Person2Id = Person_knows_Person_Delete_candidates.src)
;
