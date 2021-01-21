-- static tables

create table Organisation (
    id bigint not null,
    type varchar(12) not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isLocatedIn_Place bigint
);

create table Place (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    type varchar(12) not null,
    isPartOf_Place bigint
);

create table TagClass (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    hasType_TagClass bigint
);

create table Tag (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isSubclassOf_TagClass bigint not null
);

-- dynamic tables

create table Comment (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    content varchar(2000) not null,
    length int not null,
    hasCreator_Person bigint not null,
    isLocatedIn_Place bigint not null,
    replyOf_Post bigint,
    replyOf_Comment bigint
);

create table Comment_hasTag_Tag (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    hasTag_Tag bigint not null
);

create table Forum (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    title varchar(256) not null,
    hasModerator_Person bigint not null
);

create table Forum_hasMember_Person (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    hasMember_Person bigint not null
);

create table Forum_hasTag_Tag (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    hasTag_Tag bigint not null
);

create table Person (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    firstName varchar(40) not null,
    lastName varchar(40) not null,
    gender varchar(40) not null,
    birthday date not null,
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    isLocatedIn_Place bigint not null,
    speaks varchar(640) not null,
    email varchar(8192) not null
);

create table Person_hasInterest_Tag (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    hasInterest_Tag bigint not null
);

create table Person_knows_Person (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    Person1id bigint not null,
    Person2id bigint not null
);

create table Person_likes_Comment (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    likes_Comment bigint not null
);

create table Person_likes_Post (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    likes_Post bigint not null
);

create table Person_studyAt_University (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    studyAt_University bigint not null,
    classYear int not null
);

create table Person_workAt_Company (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    workAt_Company bigint not null,
    workFrom int not null
);

create table Post (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    explicitlyDeleted boolean not null,
    id bigint not null,
    imageFile varchar(40),
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    language varchar(40),
    content varchar(2000),
    length int not null,
    hasCreator_Person bigint not null,
    Forum_containerOf bigint not null,
    isLocatedIn_Place bigint not null
);

create table Post_hasTag_Tag (
    creationDate timestamp without time zone not null,
    deletionDate timestamp without time zone not null,
    id bigint not null,
    hasTag_Tag bigint not null
);
