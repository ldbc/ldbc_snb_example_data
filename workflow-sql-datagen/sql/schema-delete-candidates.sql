CREATE TABLE Person_Delete_candidates                (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Forum_Delete_candidates                 (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Comment_Delete_candidates               (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Post_Delete_candidates                  (deletionDate timestamp without time zone not null, id bigint);
CREATE TABLE Person_likes_Comment_Delete_candidates  (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Person_likes_Post_Delete_candidates     (deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Forum_hasMember_Person_Delete_candidates(deletionDate timestamp without time zone not null, src bigint, trg bigint);
CREATE TABLE Person_knows_Person_Delete_candidates   (deletionDate timestamp without time zone not null, src bigint, trg bigint);
