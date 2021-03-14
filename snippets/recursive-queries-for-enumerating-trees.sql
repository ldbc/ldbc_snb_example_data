WITH RECURSIVE extended_tags(subTagClassId, superTagClassId) AS (
    SELECT id, id
    FROM TagClass
    UNION
    SELECT tc.id, et.superTagClassId
    FROM TagClass tc, extended_tags et
    WHERE tc.isSubclassOf_TagClass = et.superTagClassId
)
SELECT *
FROM extended_tags
ORDER BY subTagClassId, superTagClassId
;

WITH RECURSIVE message_tree(commentId, postId) AS (
    SELECT id, replyOf_Post
    FROM Comment
    WHERE replyOf_Post IS NOT NULL
    UNION
    SELECT id, mt.postId
    FROM Comment, message_tree mt
    WHERE replyOf_Comment = mt.commentId
)
SELECT *
FROM message_tree
ORDER BY commentId
;
