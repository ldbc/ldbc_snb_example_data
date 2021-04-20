CREATE TABLE IF NOT EXISTS Delete_Candidates_Person                (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Forum                 (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Comment               (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Post                  (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Person_likes_Comment  (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Person_likes_Post     (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Forum_hasMember_Person(deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE IF NOT EXISTS Delete_Candidates_Person_knows_Person   (deletionDate timestamp without time zone not null, src bigint, trg bigint);
