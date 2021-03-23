library("DBI")
con = dbConnect(duckdb::duckdb(), ":ldbc:")

invisible(dbExecute(con, "CREATE TABLE Organisation (
    id bigint not null,
    type varchar(12) not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isLocatedIn_Place bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Place (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    type varchar(12) not null,
    isPartOf_Place bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Tag (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    hasType_TagClass bigint not null
)"))

invisible(dbExecute(con, "CREATE TABLE TagClass (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isSubclassOf_TagClass bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Company (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isLocatedIn_Country bigint
)"))

invisible(dbExecute(con, "CREATE TABLE University (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isLocatedIn_City bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Continent (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null
)"))

invisible(dbExecute(con, "CREATE TABLE Country (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isPartOf_Continent bigint
)"))

invisible(dbExecute(con, "CREATE TABLE City (
    id bigint not null,
    name varchar(256) not null,
    url varchar(256) not null,
    isPartOf_Country bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Comment (
    id bigint not null,
    content varchar(2000) not null,
    hasCreator_Person bigint not null,
    isLocatedIn_Country bigint not null,
    replyOf_Post bigint,
    replyOf_Comment bigint
)"))

invisible(dbExecute(con, "CREATE TABLE Forum (
    id bigint not null,
    title varchar(256) not null,
    hasModerator_Person bigint not null
)"))
invisible(dbExecute(con, "CREATE TABLE Post (
    id bigint not null,
    content varchar(2000),
    hasCreator_Person bigint not null,
    Forum_containerOf bigint not null,
    isLocatedIn_Country bigint not null
)"))

invisible(dbExecute(con, "CREATE TABLE Person (
    id bigint not null,
    firstName varchar(40) not null,
    lastName varchar(40) not null,
    isLocatedIn_City bigint not null
)"))

invisible(dbExecute(con, "CREATE TABLE Comment_hasTag_Tag        ( id        bigint not null, hasTag_Tag         bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Post_hasTag_Tag           ( id        bigint not null, hasTag_Tag         bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Forum_hasMember_Person    ( id        bigint not null, hasMember_Person   bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Forum_hasTag_Tag          ( id        bigint not null, hasTag_Tag         bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_hasInterest_Tag    ( id        bigint not null, hasInterest_Tag    bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_likes_Comment      ( id        bigint not null, likes_Comment      bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_likes_Post         ( id        bigint not null, likes_Post         bigint not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_studyAt_University ( id        bigint not null, studyAt_University bigint not null, classYear int not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_workAt_Company     ( id        bigint not null, workAt_Company     bigint not null, workFrom  int not null)"))
invisible(dbExecute(con, "CREATE TABLE Person_knows_Person       ( Person1id bigint not null, Person2id          bigint not null)"))
