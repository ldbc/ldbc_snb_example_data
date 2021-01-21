create table Singular_MergedFK_Person (
    creationDate timestamp without time zone not null,
    id bigint not null,
    firstName varchar(40) not null,
    lastName varchar(40) not null,
    gender varchar(40) not null,
    birthday date not null,
    locationIP varchar(40) not null,
    browserUsed varchar(40) not null,
    isLocatedIn_Place bigint not null
);
create table Singular_MergedFK_speaks (
    creationDate timestamp without time zone not null,
    id bigint not null,
    speaks varchar(40) not null
);
create table Singular_MergedFK_email (
    creationDate timestamp without time zone not null,
    id bigint not null,
    email varchar(256) not null
);
