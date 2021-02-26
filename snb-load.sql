-- static entities

COPY Raw_Organisation              FROM '${PATHVAR}/static/Organisation${POSTFIX}'                 (DELIMITER '|' ${HEADER});
COPY Raw_Place                     FROM '${PATHVAR}/static/Place${POSTFIX}'                        (DELIMITER '|' ${HEADER});
COPY Raw_Tag                       FROM '${PATHVAR}/static/Tag${POSTFIX}'                          (DELIMITER '|' ${HEADER});
COPY Raw_TagClass                  FROM '${PATHVAR}/static/TagClass${POSTFIX}'                     (DELIMITER '|' ${HEADER});

-- dynamic entities

COPY Raw_Comment                   FROM '${PATHVAR}/dynamic/Comment${POSTFIX}'                     (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Comment_hasTag_Tag        FROM '${PATHVAR}/dynamic/Comment_hasTag_Tag${POSTFIX}'          (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Post                      FROM '${PATHVAR}/dynamic/Post${POSTFIX}'                        (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Post_hasTag_Tag           FROM '${PATHVAR}/dynamic/Post_hasTag_Tag${POSTFIX}'             (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum                     FROM '${PATHVAR}/dynamic/Forum${POSTFIX}'                       (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum_hasMember_Person    FROM '${PATHVAR}/dynamic/Forum_hasMember_Person${POSTFIX}'      (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Forum_hasTag_Tag          FROM '${PATHVAR}/dynamic/Forum_hasTag_Tag${POSTFIX}'            (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person                    FROM '${PATHVAR}/dynamic/Person${POSTFIX}'                      (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_hasInterest_Tag    FROM '${PATHVAR}/dynamic/Person_hasInterest_Tag${POSTFIX}'      (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_studyAt_University FROM '${PATHVAR}/dynamic/Person_studyAt_University${POSTFIX}'   (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_workAt_Company     FROM '${PATHVAR}/dynamic/Person_workAt_Company${POSTFIX}'       (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_likes_Post         FROM '${PATHVAR}/dynamic/Person_likes_Post${POSTFIX}'           (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_likes_Comment      FROM '${PATHVAR}/dynamic/Person_likes_Comment${POSTFIX}'        (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
COPY Raw_Person_knows_Person       FROM '${PATHVAR}/dynamic/Person_knows_Person${POSTFIX}'         (DELIMITER '|' ${HEADER}, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00');
