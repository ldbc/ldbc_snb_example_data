-- static tables

COPY Organisation FROM 'PATHVAR/static/organisationPOSTFIX' (DELIMITER '|', HEADER);
COPY Place        FROM 'PATHVAR/static/placePOSTFIX'        (DELIMITER '|', HEADER);
COPY Tag          FROM 'PATHVAR/static/tagPOSTFIX'          (DELIMITER '|', HEADER);
COPY TagClass     FROM 'PATHVAR/static/tagclassPOSTFIX'     (DELIMITER '|', HEADER);

-- dynamic tables

COPY Comment                   FROM 'PATHVAR/dynamic/commentPOSTFIX'                     (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Comment_hasTag_Tag        FROM 'PATHVAR/dynamic/comment_hasTag_tagPOSTFIX'          (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

COPY Post                      FROM 'PATHVAR/dynamic/postPOSTFIX'                        (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Post_hasTag_Tag           FROM 'PATHVAR/dynamic/post_hasTag_tagPOSTFIX'             (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

COPY Forum                     FROM 'PATHVAR/dynamic/forumPOSTFIX'                       (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Forum_hasMember_Person    FROM 'PATHVAR/dynamic/forum_hasMember_personPOSTFIX'      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Forum_hasTag_Tag          FROM 'PATHVAR/dynamic/forum_hasTag_tagPOSTFIX'            (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

COPY Person                    FROM 'PATHVAR/dynamic/personPOSTFIX'                      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_hasInterest_Tag    FROM 'PATHVAR/dynamic/person_hasInterest_tagPOSTFIX'      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_studyAt_University FROM 'PATHVAR/dynamic/person_studyAt_organisationPOSTFIX' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_workAt_Company     FROM 'PATHVAR/dynamic/person_workAt_organisationPOSTFIX'  (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_likes_Post         FROM 'PATHVAR/dynamic/person_likes_postPOSTFIX'           (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_likes_Comment      FROM 'PATHVAR/dynamic/person_likes_commentPOSTFIX'        (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

COPY Person_knows_Person ( creationDate, deletionDate, explicitlyDeleted, person1id, person2id) FROM 'PATHVAR/dynamic/person_knows_personPOSTFIX' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Person_knows_Person ( creationDate, deletionDate, explicitlyDeleted, person2id, person1id) FROM 'PATHVAR/dynamic/person_knows_personPOSTFIX' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

COPY (SELECT id, unnest(string_split_regex(email,  ';')) AS email FROM person) TO 'Person_email.csv'  WITH (HEADER, DELIMITER '|');
COPY (SELECT id, unnest(string_split_regex(speaks, ';')) AS email FROM person) TO 'Person_speaks.csv' WITH (HEADER, DELIMITER '|');
