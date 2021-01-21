-- basic
-- INSERT INTO Organisation SELECT * FROM Organisation;
-- INSERT INTO Place        SELECT * FROM Place;
-- INSERT INTO Tag          SELECT * FROM Tag;
-- INSERT INTO TagClass     SELECT * FROM TagClass;

-- create table MergedFK_Organisation (id, type, name, url, isLocatedIn_Place, 
-- create table MergedFK_Place (id, name, url, type, isPartOf_Place, );
-- create table MergedFK_TagClass (id, name, url, hasType_TagClass, 
-- create table MergedFK_Tag (id, name, url, isSubclassOf_TagClass

-- static
INSERT INTO MergedFK_Organisation SELECT * FROM Raw_Organisation;       
INSERT INTO MergedFK_Place        SELECT * FROM Raw_Place;      
INSERT INTO MergedFK_TagClass     SELECT * FROM Raw_TagClass;
INSERT INTO MergedFK_Tag          SELECT * FROM Raw_Tag;   

-- CsvCompositeMergeForeign = many-to-many edges + merge-foreign tables + person-composite-merge-foreign

-- dynamic
-- many-to-many-edges
INSERT INTO Edge_Comment_hasTag_Tag        SELECT creationDate, id, hasTag_Tag                    FROM Raw_Comment_hasTag_Tag        WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Post_hasTag_Tag           SELECT creationDate, id, hasTag_Tag                    FROM Raw_Post_hasTag_Tag           WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Forum_hasMember_Person    SELECT creationDate, id, hasMember_Person              FROM Raw_Forum_hasMember_Person    WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Forum_hasTag_Tag          SELECT creationDate, id, hasTag_Tag                    FROM Raw_Forum_hasTag_Tag          WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_hasInterest_Tag    SELECT creationDate, id, hasInterest_Tag               FROM Raw_Person_hasInterest_Tag    WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_likes_Comment      SELECT creationDate, id, likes_Comment                 FROM Raw_Person_likes_Comment      WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_likes_Post         SELECT creationDate, id, likes_Post                    FROM Raw_Person_likes_Post         WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_studyAt_University SELECT creationDate, id, studyAt_University, classYear FROM Raw_Person_studyAt_University WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_workAt_Company     SELECT creationDate, id, workAt_Company, workFrom      FROM Raw_Person_workAt_Company     WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO Edge_Person_knows_Person       SELECT creationDate, Person1id, Person2id              FROM Raw_Person_knows_Person       WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;

-- Forums/Messages and their many-to-one edges
INSERT INTO MergedFK_Comment SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment          FROM Raw_Comment WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO MergedFK_Forum   SELECT creationDate, id, title, hasModerator_Person                                                                                             FROM Raw_Forum   WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
INSERT INTO MergedFK_Post    SELECT creationDate, id, imageFile, locationIP, browserUsed, language, content, length, hasCreator_Person, Forum_containerOf, isLocatedIn_Place FROM Raw_Post    WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;

-- Persons
INSERT INTO Composite_MergedFK_Person SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_Place, speaks, email FROM Raw_Person WHERE creationDate < :bulkLoadTime AND deletionDate >= :bulkLoadTime;
