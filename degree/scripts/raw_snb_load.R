library("DBI")
con = dbConnect(duckdb::duckdb(), ":ldbc:")

dir = Sys.getenv(c("LDBC_DATA_DIRECTORY"))

orgs = dbExecute(con, paste0("COPY Raw_Organisation FROM '",dir,"/static/Organisation_0_0.csv' (DELIMITER '|')"))
cat(paste0("loaded ",orgs," Organisation(s)\n"))

places = dbExecute(con, paste0("COPY Raw_Place FROM '",dir,"/static/Place_0_0.csv' (DELIMITER '|')"))
cat(paste0("loaded ",places," Place(s)\n"))

tags = dbExecute(con, paste0("COPY Raw_Tag FROM '",dir,"/static/Tag_0_0.csv' (DELIMITER '|')"))
cat(paste0("loaded ",tags," Tag(s)\n"))

tagclasses = dbExecute(con, paste0("COPY Raw_TagClass FROM '",dir,"/static/TagClass_0_0.csv' (DELIMITER '|')"))
cat(paste0("loaded ",tagclasses," TagClass(es)\n"))

comment = dbExecute(con, paste0("COPY Raw_Comment FROM '",dir,"/dynamic/Comment_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",comment," Comment(s)\n"))

cht = dbExecute(con, paste0("COPY Raw_Comment_hasTag_Tag FROM '",dir,"/dynamic/Comment_hasTag_Tag_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",cht," Comment_hasTag_Tag(s)\n"))

post = dbExecute(con, paste0("COPY Raw_Post FROM '",dir,"/dynamic/Post_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",post," Post(s)\n"))

pht = dbExecute(con, paste0("COPY Raw_Post_hasTag_Tag  FROM '",dir,"/dynamic/Post_hasTag_Tag_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",pht," Post_hasTag_Tag(s)\n"))

forum = dbExecute(con, paste0("COPY Raw_Forum FROM '",dir,"/dynamic/Forum_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",forum," Forum(s)\n"))

fhp = dbExecute(con, paste0("COPY Raw_Forum_hasMember_Person FROM '",dir,"/dynamic/Forum_hasMember_Person_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",fhp," Forum_hasMemb_Person(s)\n"))

fht = dbExecute(con, paste0("COPY Raw_Forum_hasTag_Tag FROM '",dir,"/dynamic/Forum_hasTag_Tag_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",fht," Forum_hasTag_Tag(s)\n"))

pers = dbExecute(con, paste0("COPY Raw_Person FROM '",dir,"/dynamic/Person_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",pers," Person(s)\n"))

pht = dbExecute(con, paste0("COPY Raw_Person_hasInterest_Tag FROM '",dir,"/dynamic/Person_hasInterest_Tag_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",pht," Person_hasInterest_Tag(s)\n"))


psau = dbExecute(con, paste0("COPY Raw_Person_studyAt_University FROM '",dir,"/dynamic/Person_studyAt_University_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",psau," Person_studyAt_University(s)\n"))


pwac = dbExecute(con, paste0("COPY Raw_Person_workAt_Company FROM '",dir,"/dynamic/Person_workAt_Company_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",pwac," Person_workAt_Companyy(s)\n"))


plp = dbExecute(con, paste0("COPY Raw_Person_likes_Post FROM '",dir,"/dynamic/Person_likes_Post_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",plp," Person_likes_Post(s)\n"))


plc = dbExecute(con, paste0("COPY Raw_Person_likes_Comment FROM '",dir,"/dynamic/Person_likes_Comment_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",plc," Person_likes_Comment(s)\n"))


pkp = dbExecute(con, paste0("COPY Raw_Person_knows_Person FROM '",dir,"/dynamic/Person_knows_Person_0_0.csv' (DELIMITER '|', TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')"))
cat(paste0("loaded ",pkp," Person_knows_Person(s)\n"))
