DROP VIEW IF EXISTS Message;

DROP TABLE IF EXISTS Organisation;
DROP TABLE IF EXISTS Place;
DROP TABLE IF EXISTS Tag;
DROP TABLE IF EXISTS TagClass;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS University;
DROP TABLE IF EXISTS Continent;
DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Forum;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Comment_hasTag_Tag;
DROP TABLE IF EXISTS Post_hasTag_Tag;
DROP TABLE IF EXISTS Forum_hasMember_Person;
DROP TABLE IF EXISTS Forum_hasTag_Tag;
DROP TABLE IF EXISTS Person_hasInterest_Tag;
DROP TABLE IF EXISTS Person_likes_Comment;
DROP TABLE IF EXISTS Person_likes_Post;
DROP TABLE IF EXISTS Person_studyAt_University;
DROP TABLE IF EXISTS Person_workAt_Company;
DROP TABLE IF EXISTS Person_knows_Person;

-- static tables

CREATE TABLE Organisation (
    id bigint not null,
    type varchar(12) not null,
    name varchar(256) not null,
    url varchar(256) not null,
    LocationPlaceId bigint
);

CREATE TABLE Place (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    type varchar(12) not null,
    PartOfPlaceId bigint
);

CREATE TABLE Tag (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    TypeTagClassId bigint not null
);

CREATE TABLE TagClass (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    SubclassOfTagClassId bigint
);

-- static tables / separate table per individual subtype

-- CREATE TABLE Company (
--     id bigint not null,
--     name varchar(256) not null,
--     url varchar(256) not null,
--     isLocatedIn_Country bigint
-- );

-- CREATE TABLE University (
--     id bigint not null,
--     name varchar(256) not null,
--     url varchar(256) not null,
--     isLocatedIn_City bigint
-- );

-- CREATE TABLE Continent (
--     id bigint not null,
--     name varchar(256) not null,
--     url varchar(256) not null
-- );

-- CREATE TABLE Country (
--     id bigint not null,
--     name varchar(256) not null,
--     url varchar(256) not null,
--     isPartOf_Continent bigint
-- );

-- CREATE TABLE City (
--     id bigint not null,
--     name varchar(256) not null,
--     url varchar(256) not null,
--     isPartOf_Country bigint
-- );

-- dynamic tables

CREATE TABLE Comment (
    creationDate timestamp without time zone not null,
    id bigint not null,
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    content varchar(2000) not null,
    length int not null,
    CreatorPersonId bigint not null,
    LocationCountryId bigint not null,
    ParentPostId bigint,
    ParentCommentId bigint
);

CREATE TABLE Forum (
    creationDate timestamp without time zone not null,
    id bigint not null,
    title varchar(256) not null,
    ModeratorPersonId bigint
);

CREATE TABLE Post (
    creationDate timestamp without time zone not null,
    id bigint not null,
    imageFile varchar(40),
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    language varchar(40),
    content varchar(2000),
    length int not null,
    CreatorPersonId bigint not null,
    ContainerForumId bigint not null,
    LocationCountryId bigint not null
);

CREATE TABLE Person (
    creationDate timestamp without time zone not null,
    id bigint not null,
    firstName varchar(40) not null,
    lastName varchar(40) not null,
    gender varchar(40) not null,
    birthday date not null,
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    LocationCityId bigint not null,
    speaks varchar(640) not null,
    email varchar(8192) not null
);

-- edges
CREATE TABLE Comment_hasTag_Tag        (creationDate timestamp without time zone not null, id bigint not null, TagId bigint not null);
CREATE TABLE Post_hasTag_Tag           (creationDate timestamp without time zone not null, id bigint not null, TagId bigint not null);
CREATE TABLE Forum_hasMember_Person    (creationDate timestamp without time zone not null, id bigint not null, PersonId bigint not null);
CREATE TABLE Forum_hasTag_Tag          (creationDate timestamp without time zone not null, id bigint not null, TagId bigint not null);
CREATE TABLE Person_hasInterest_Tag    (creationDate timestamp without time zone not null, id bigint not null, TagId bigint not null);
CREATE TABLE Person_likes_Comment      (creationDate timestamp without time zone not null, id bigint not null, CommentId bigint not null);
CREATE TABLE Person_likes_Post         (creationDate timestamp without time zone not null, id bigint not null, PostId bigint not null);
CREATE TABLE Person_studyAt_University (creationDate timestamp without time zone not null, id bigint not null, UniversityId bigint not null, classYear int not null);
CREATE TABLE Person_workAt_Company     (creationDate timestamp without time zone not null, id bigint not null, CompanyId bigint not null, workFrom  int not null);
CREATE TABLE Person_knows_Person       (creationDate timestamp without time zone not null, Person1id bigint not null, Person2id bigint not null);
