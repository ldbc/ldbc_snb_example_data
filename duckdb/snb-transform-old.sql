-- basic
-- static
INSERT INTO Basic_Organisation                   SELECT id, type, name, url                                                              FROM Organisation;
INSERT INTO Basic_Organisation_isLocatedIn_Place SELECT id, isLocatedIn_Place                                                            FROM Organisation;
INSERT INTO Basic_Place                          SELECT id, name, url, type                                                              FROM Place;
INSERT INTO Basic_Place_isPartOf_Place           SELECT id, isPartOf_Place                                                               FROM Place;
INSERT INTO Basic_TagClass                       SELECT id, name, url                                                                    FROM TagClass;
INSERT INTO Basic_TagClass_hasType_TagClass      SELECT id, hasType_TagClass                                                             FROM TagClass;
INSERT INTO Basic_Tag                            SELECT id, name, url                                                                    FROM Tag;
INSERT INTO Basic_Tag_isSubclassOf_TagClass      SELECT id, isSubclassOf_TagClass                                                        FROM Tag;

-- dynamic
INSERT INTO Basic_Comment                        SELECT creationDate, id, locationIP, browserUsed, content, length                       FROM Comment WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Comment_hasCreator_Person      SELECT creationDate, id, hasCreator_Person                                              FROM Comment WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Comment_isLocatedIn_Place      SELECT creationDate, id, isLocatedIn_Place                                              FROM Comment WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Comment_replyOf_Post           SELECT creationDate, id, replyOf_Post                                                   FROM Comment WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Comment_replyOf_Comment        SELECT creationDate, id, replyOf_Comment                                                FROM Comment WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Forum                          SELECT creationDate, id, title                                                          FROM Forum   WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Forum_hasModerator_Person      SELECT creationDate, id, hasModerator_Person                                            FROM Forum   WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Post                           SELECT creationDate, id, imageFile, locationIP, browserUsed, language, content, length  FROM Post    WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Post_hasCreator_Person         SELECT creationDate, id, hasCreator_Person                                              FROM Post    WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Post_Forum_containerOf         SELECT creationDate, id, Forum_containerOf                                              FROM Post    WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Post_isLocatedIn_Place         SELECT creationDate, id, isLocatedIn_Place                                              FROM Post    WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Person                         SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed FROM Person  WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Person_isLocatedIn_Place       SELECT creationDate, id, isLocatedIn_Place                                              FROM Person  WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Person_speaks                  SELECT creationDate, id, speaks                                                         FROM Person  WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Basic_Person_email                   SELECT creationDate, id, email                                                          FROM Person  WHERE deletionDate >= :bulkLoadTime;

-- merge-foreign plus composite variants for persons
-- static
INSERT INTO MergeForeign_Organisation     SELECT id, type, name, url, isLocatedIn_Place                                                                                                   FROM Organisation;
INSERT INTO MergeForeign_Place            SELECT id, name, url, type, isPartOf_Place                                                                                                      FROM Place;
INSERT INTO MergeForeign_TagClass         SELECT id, name, url, hasType_TagClass                                                                                                          FROM TagClass;
INSERT INTO MergeForeign_Tag              SELECT id, name, url, isSubclassOf_TagClass                                                                                                     FROM Tag;

-- dynamic
INSERT INTO MergeForeign_Comment          SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment          FROM Comment      WHERE deletionDate >= :bulkLoadTime;
INSERT INTO MergeForeign_Forum            SELECT creationDate, id, title, hasModerator_Person                                                                                             FROM Forum        WHERE deletionDate >= :bulkLoadTime;
INSERT INTO MergeForeign_Post             SELECT creationDate, id, imageFile, locationIP, browserUsed, language, content, length, hasCreator_Person, Forum_containerOf, isLocatedIn_Place FROM Post         WHERE deletionDate >= :bulkLoadTime;
INSERT INTO MergeForeign_Person           SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_Place, speaks, email                       FROM Person       WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Composite_Person              SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, speaks, email                                          FROM Person       WHERE deletionDate >= :bulkLoadTime;
INSERT INTO Composite_MergeForeign_Person SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_Place, speaks, email                       FROM Person       WHERE deletionDate >= :bulkLoadTime;
