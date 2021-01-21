-- static entities

COPY Raw_Organisation              FROM '${PATHVAR}/static/organisation${POSTFIX}'                 (DELIMITER '|', HEADER);
COPY Raw_Place                     FROM '${PATHVAR}/static/place${POSTFIX}'                        (DELIMITER '|', HEADER);
COPY Raw_Tag                       FROM '${PATHVAR}/static/tag${POSTFIX}'                          (DELIMITER '|', HEADER);
COPY Raw_TagClass                  FROM '${PATHVAR}/static/tagclass${POSTFIX}'                     (DELIMITER '|', HEADER);

-- dynamic entities

COPY Raw_Comment                   FROM '${PATHVAR}/dynamic/comment${POSTFIX}'                     (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Comment_hasTag_Tag        FROM '${PATHVAR}/dynamic/comment_hasTag_tag${POSTFIX}'          (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Post                      FROM '${PATHVAR}/dynamic/post${POSTFIX}'                        (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Post_hasTag_Tag           FROM '${PATHVAR}/dynamic/post_hasTag_tag${POSTFIX}'             (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum                     FROM '${PATHVAR}/dynamic/forum${POSTFIX}'                       (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum_hasMember_Person    FROM '${PATHVAR}/dynamic/forum_hasMember_person${POSTFIX}'      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum_hasTag_Tag          FROM '${PATHVAR}/dynamic/forum_hasTag_tag${POSTFIX}'            (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person                    FROM '${PATHVAR}/dynamic/person${POSTFIX}'                      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_hasInterest_Tag    FROM '${PATHVAR}/dynamic/person_hasInterest_tag${POSTFIX}'      (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_studyAt_University FROM '${PATHVAR}/dynamic/person_studyAt_organisation${POSTFIX}' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_workAt_Company     FROM '${PATHVAR}/dynamic/person_workAt_organisation${POSTFIX}'  (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_likes_Post         FROM '${PATHVAR}/dynamic/person_likes_post${POSTFIX}'           (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_likes_Comment      FROM '${PATHVAR}/dynamic/person_likes_comment${POSTFIX}'        (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');

-- Person-KNOWS-Person edges are undirected so they should exist in both ways
COPY Raw_Person_knows_Person ( creationDate, deletionDate, explicitlyDeleted, person1id, person2id) FROM '${PATHVAR}/dynamic/person_knows_person${POSTFIX}' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_knows_Person ( creationDate, deletionDate, explicitlyDeleted, person2id, person1id) FROM '${PATHVAR}/dynamic/person_knows_person${POSTFIX}' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
