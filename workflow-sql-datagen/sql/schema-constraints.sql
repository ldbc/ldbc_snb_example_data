-- PKs

-- static nodes
ALTER TABLE Organisation ADD PRIMARY KEY (id);
ALTER TABLE Place ADD PRIMARY KEY (id);
ALTER TABLE Tag ADD PRIMARY KEY (id);
ALTER TABLE TagClass ADD PRIMARY KEY (id);

-- dynamic nodes
ALTER TABLE Comment ADD PRIMARY KEY (id);
ALTER TABLE Forum ADD PRIMARY KEY (id);
ALTER TABLE Post ADD PRIMARY KEY (id);
ALTER TABLE Person ADD PRIMARY KEY (id);

-- dynamic edges
ALTER TABLE Comment_hasTag_Tag ADD PRIMARY KEY (id, TagId);
ALTER TABLE Post_hasTag_Tag ADD PRIMARY KEY (id, TagId);
ALTER TABLE Forum_hasMember_Person ADD PRIMARY KEY (id, PersonId);
ALTER TABLE Forum_hasTag_Tag ADD PRIMARY KEY (id, TagId);
ALTER TABLE Person_hasInterest_Tag ADD PRIMARY KEY (id, TagId);
ALTER TABLE Person_likes_Comment ADD PRIMARY KEY (id, CommentId);
ALTER TABLE Person_likes_Post ADD PRIMARY KEY (id, PostId);
ALTER TABLE Person_studyAt_University ADD PRIMARY KEY (id, UniversityId);
ALTER TABLE Person_workAt_Company ADD PRIMARY KEY (id, CompanyId);
ALTER TABLE Person_knows_Person ADD PRIMARY KEY (Person1Id, Person2Id);

-- Analyze

VACUUM ANALYZE;

-- Indexes for FKs

CREATE INDEX Organisation_LocationPlaceId ON Organisation (LocationPlaceId);
CREATE INDEX Place_PartOfPlaceId ON Place (PartOfPlaceId);
CREATE INDEX Tag_TypeTagClassId ON Tag (TypeTagClassId);
CREATE INDEX TagClass_SubclassOfTagClassId ON TagClass (SubclassOfTagClassId);

CREATE INDEX Forum_ModeratorPersonId ON Forum (ModeratorPersonId);
CREATE INDEX Person_LocationCityId ON Person (LocationCityId);
CREATE INDEX Comment_CreatorPersonId ON Comment (CreatorPersonId);
CREATE INDEX Comment_LocationCountryId ON Comment (LocationCountryId);
CREATE INDEX Comment_ParentPostId ON Comment (ParentPostId);
CREATE INDEX Comment_ParentCommentId ON Comment (ParentCommentId);
CREATE INDEX Post_CreatorPersonId ON Post (CreatorPersonId);
CREATE INDEX Post_ContainerForumId ON Post (ContainerForumId);
CREATE INDEX Post_LocationCountryId ON Post (LocationCountryId);

CREATE INDEX Comment_hasTag_Tag_id ON Comment_hasTag_Tag(id);
CREATE INDEX Post_hasTag_Tag_id ON Post_hasTag_Tag(id);
CREATE INDEX Forum_hasMember_Person_id ON Forum_hasMember_Person(id);
CREATE INDEX Forum_hasTag_Tag_id ON Forum_hasTag_Tag(id);
CREATE INDEX Person_hasInterest_Tag_id ON Person_hasInterest_Tag(id);
CREATE INDEX Person_likes_Comment_id ON Person_likes_Comment(id);
CREATE INDEX Person_likes_Post_id ON Person_likes_Post(id);
CREATE INDEX Person_studyAt_University_id ON Person_studyAt_University(id);
CREATE INDEX Person_workAt_Company_id ON Person_workAt_Company(id);

CREATE INDEX Comment_hasTag_Tag_TagId ON Comment_hasTag_Tag(TagId);
CREATE INDEX Post_hasTag_Tag_TagId ON Post_hasTag_Tag(TagId);
CREATE INDEX Forum_hasMember_Person_PersonId ON Forum_hasMember_Person(PersonId);
CREATE INDEX Forum_hasTag_Tag_TagId ON Forum_hasTag_Tag(TagId);
CREATE INDEX Person_hasInterest_Tag_TagId ON Person_hasInterest_Tag(TagId);
CREATE INDEX Person_likes_Comment_CommentId ON Person_likes_Comment(CommentId);
CREATE INDEX Person_likes_Post_PostId ON Person_likes_Post(PostId);
CREATE INDEX Person_studyAt_University_UniversityId ON Person_studyAt_University(UniversityId);
CREATE INDEX Person_workAt_Company_CompanyId ON Person_workAt_Company(CompanyId);

CREATE INDEX Person_knows_Person_Person1id ON Person_knows_Person(Person1id);
CREATE INDEX Person_knows_Person_Person2id ON Person_knows_Person(Person2id);

-- views

CREATE VIEW Message AS
    SELECT creationDate, id, content, NULL AS imageFile, locationIP, browserUsed, NULL AS language, length, CreatorPersonId, NULL AS ContainerForumId, LocationCountryId, coalesce(ParentPostId, ParentCommentId) AS ParentMessageId
    FROM Comment
    UNION ALL
    SELECT creationDate, id, content, imageFile, locationIP, browserUsed, language, length, CreatorPersonId, ContainerForumId, LocationCountryId, NULL AS ParentMessageId
    FROM Post
;
