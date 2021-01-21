-- static tables

create table MergeForeign_Organisation (
    id bigint not null,
    type varchar(12) not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isLocatedIn_Place bigint
);

create table MergeForeign_Place (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    type varchar(12) not null,
    isPartOf_Place bigint
);

create table MergeForeign_TagClass (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    hasType_TagClass bigint
);

create table MergeForeign_Tag (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isSubclassOf_TagClass bigint not null
);

-- dynamic tables

create table MergeForeign_Comment (
    creationDate timestamp without time zone not null,
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

create table MergeForeign_Forum (
    creationDate timestamp without time zone not null,
    id bigint not null,
    title varchar(256) not null,
    hasModerator_Person bigint not null
);
create table MergeForeign_Post (
    creationDate timestamp without time zone not null,
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
