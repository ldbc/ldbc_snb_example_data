CREATE TABLE Delete_Person                (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Delete_Forum                 (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Delete_Comment               (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Delete_Post                  (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Delete_Person_likes_Comment  (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Delete_Person_likes_Post     (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Delete_Forum_hasMember_Person(deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Delete_Person_knows_Person   (deletionDate timestamp without time zone not null, src bigint, trg bigint);
