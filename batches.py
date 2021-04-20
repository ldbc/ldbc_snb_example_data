import duckdb
from datetime import date, timedelta
from dateutil.relativedelta import relativedelta
import os
import shutil

con = duckdb.connect(database='ldbc.duckdb', read_only=False)

# batches are selected from the [network_start_date, network_end_date) interval,
# each batch denotes a [batch_start_date, batch_end_date) where
# batch_end_date = batch_start_date + batch_size
network_start_date = date(2011, 1, 1)
network_end_date   = date(2014, 1, 1)
batch_size         = relativedelta(years=1)


if os.path.isdir("batches"):
    shutil.rmtree("batches")
os.mkdir("batches")

batch_start_date = network_start_date
while batch_start_date < network_end_date:
    batch_end_date = batch_start_date + batch_size

    interval = [batch_start_date, batch_end_date]
    print(f"Batch: {interval}")

    ######################################## cleanup #######################################

    # clean insert tables
    con.execute("DELETE FROM Person")                         # INS1
    con.execute("DELETE FROM Person_hasInterest_Tag")
    con.execute("DELETE FROM Person_studyAt_University")
    con.execute("DELETE FROM Person_workAt_Company")
    con.execute("DELETE FROM Person_likes_Post")              # INS2
    con.execute("DELETE FROM Person_likes_Comment")           # INS3
    con.execute("DELETE FROM Forum")                          # INS4
    con.execute("DELETE FROM Forum_hasTag_Tag")
    con.execute("DELETE FROM Forum_hasMember_Person")         # INS5
    con.execute("DELETE FROM Post")                           # INS6
    con.execute("DELETE FROM Post_hasTag_Tag")
    con.execute("DELETE FROM Comment")                        # INS7
    con.execute("DELETE FROM Comment_hasTag_Tag")             # INS8
    con.execute("DELETE FROM Person_knows_Person")

    # clean delete tables
    con.execute("DELETE FROM Delete_Person")                  # DEL1
    con.execute("DELETE FROM Delete_Person_likes_Post")       # DEL2
    con.execute("DELETE FROM Delete_Person_likes_Comment")    # DEL3
    con.execute("DELETE FROM Delete_Forum")                   # DEL4
    con.execute("DELETE FROM Delete_Forum_hasMember_Person")  # DEL5
    con.execute("DELETE FROM Delete_Post")                    # DEL6
    con.execute("DELETE FROM Delete_Comment")                 # DEL7
    con.execute("DELETE FROM Delete_Person_knows_Person")     # DEL8

    ######################################## inserts #######################################

    insertion_params = [batch_start_date, batch_end_date, batch_end_date]

    # INS1
    con.execute("""
        INSERT INTO Person
        SELECT creationDate, id, firstName, lastName, gender, birthday, locationIP, browserUsed, isLocatedIn_Place, speaks, email
        FROM Raw_Person
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Person_hasInterest_Tag
        SELECT creationDate, id, hasInterest_Tag
        FROM Raw_Person_hasInterest_Tag
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Person_studyAt_University
        SELECT creationDate, id, studyAt_University, classYear
        FROM Raw_Person_studyAt_University
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Person_workAt_Company
        SELECT creationDate, id, workAt_Company, workFrom
        FROM Raw_Person_workAt_Company
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS2
    con.execute("""
        INSERT INTO Person_likes_Post
        SELECT creationDate, id, likes_Post
        FROM Raw_Person_likes_Post
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS3
    con.execute("""
        INSERT INTO Person_likes_Comment
        SELECT creationDate, id, likes_Comment
        FROM Raw_Person_likes_Comment
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS4
    con.execute("""
        INSERT INTO Forum
        SELECT creationDate, id, title, hasModerator_Person
        FROM Raw_Forum
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Forum_hasTag_Tag
        SELECT creationDate, id, hasTag_Tag
        FROM Raw_Forum_hasTag_Tag
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS5
    con.execute("""
        INSERT INTO Forum_hasMember_Person
        SELECT creationDate, id, hasMember_Person
        FROM Raw_Forum_hasMember_Person
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS6
    con.execute("""
        INSERT INTO Post
        SELECT creationDate, id, imageFile, locationIP, browserUsed, language, content, length, hasCreator_Person, Forum_containerOf, isLocatedIn_Place
        FROM Raw_Post
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Post_hasTag_Tag
        SELECT creationDate, id, hasTag_Tag
        FROM Raw_Post_hasTag_Tag
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS7
    con.execute("""
        INSERT INTO Comment
        SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment
        FROM Raw_Comment
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)
    con.execute("""
        INSERT INTO Comment_hasTag_Tag
        SELECT creationDate, id, hasTag_Tag
        FROM Raw_Comment_hasTag_Tag
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    # INS8
    con.execute("""
        INSERT INTO Person_knows_Person
        SELECT creationDate, Person1id, Person2id
        FROM Raw_Person_knows_Person
        WHERE creationDate >= ?
          AND creationDate < ?
          AND deletionDate >= ?
        """,
        insertion_params)

    ######################################## deletes #######################################

    deletion_params = [batch_start_date, batch_start_date, batch_end_date]

    # DEL1 (Persons are always explicitly deleted)
    con.execute("""
        INSERT INTO Delete_Person
        SELECT deletionDate, id
        FROM Raw_Person
        WHERE creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL2
    con.execute("""
        INSERT INTO Delete_Person_likes_Post
        SELECT deletionDate, id, likes_Post
        FROM Raw_Person_likes_Post
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL3
    con.execute("""
        INSERT INTO Delete_Person_likes_Comment
        SELECT deletionDate, id, likes_Comment
        FROM Raw_Person_likes_Comment
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL4 (Forums are always explicitly deleted -- TODO: check in generated data for walls/albums/groups)
    con.execute("""
        INSERT INTO Delete_Forum
        SELECT deletionDate, id
        FROM Raw_Forum
        WHERE creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL5
    con.execute("""
        INSERT INTO Delete_Forum_hasMember_Person
        SELECT deletionDate, id, hasMember_Person
        FROM Raw_Forum_hasMember_Person
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL6
    con.execute("""
        INSERT INTO Delete_Post
        SELECT deletionDate, id
        FROM Raw_Post
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL7
    con.execute("""
        INSERT INTO Delete_Comment
        SELECT deletionDate, id
        FROM Raw_Comment
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    # DEL8
    con.execute("""
        INSERT INTO Delete_Person_knows_Person
        SELECT deletionDate, Person1id, Person2id
        FROM Raw_Person_knows_Person
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate >= ?
          AND deletionDate < ?
        """,
        deletion_params)

    ######################################## export ########################################

    batch_dir = f"batches/{batch_start_date}"
    os.mkdir(f"{batch_dir}")
    os.mkdir(f"{batch_dir}/inserts")
    os.mkdir(f"{batch_dir}/deletes")

    # inserts
    con.execute(f"COPY Person                        TO 'batches/{batch_start_date}/inserts/Person.csv'                    (HEADER, FORMAT CSV, DELIMITER '|')") # INS1
    con.execute(f"COPY Person_hasInterest_Tag        TO 'batches/{batch_start_date}/inserts/Person_hasInterest_Tag.csv'    (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Person_studyAt_University     TO 'batches/{batch_start_date}/inserts/Person_studyAt_University.csv' (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Person_workAt_Company         TO 'batches/{batch_start_date}/inserts/Person_workAt_Company.csv'     (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Person_likes_Post             TO 'batches/{batch_start_date}/inserts/Person_likes_Post.csv'         (HEADER, FORMAT CSV, DELIMITER '|')") # INS2
    con.execute(f"COPY Person_likes_Comment          TO 'batches/{batch_start_date}/inserts/Person_likes_Comment.csv'      (HEADER, FORMAT CSV, DELIMITER '|')") # INS3
    con.execute(f"COPY Forum                         TO 'batches/{batch_start_date}/inserts/Forum.csv'                     (HEADER, FORMAT CSV, DELIMITER '|')") # INS4
    con.execute(f"COPY Forum_hasTag_Tag              TO 'batches/{batch_start_date}/inserts/Forum_hasTag_Tag.csv'          (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Forum_hasMember_Person        TO 'batches/{batch_start_date}/inserts/Forum_hasMember_Person.csv'    (HEADER, FORMAT CSV, DELIMITER '|')") # INS5
    con.execute(f"COPY Post                          TO 'batches/{batch_start_date}/inserts/Post.csv'                      (HEADER, FORMAT CSV, DELIMITER '|')") # INS6
    con.execute(f"COPY Post_hasTag_Tag               TO 'batches/{batch_start_date}/inserts/Post_hasTag_Tag.csv'           (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Comment                       TO 'batches/{batch_start_date}/inserts/Comment.csv'                   (HEADER, FORMAT CSV, DELIMITER '|')") # INS7
    con.execute(f"COPY Comment_hasTag_Tag            TO 'batches/{batch_start_date}/inserts/Comment_hasTag_Tag.csv'        (HEADER, FORMAT CSV, DELIMITER '|')")
    con.execute(f"COPY Person_knows_Person           TO 'batches/{batch_start_date}/inserts/Person_knows_Person.csv'       (HEADER, FORMAT CSV, DELIMITER '|')") # INS8

    # deletes
    con.execute(f"COPY Delete_Person                 TO 'batches/{batch_start_date}/deletes/Person.csv'                    (HEADER, FORMAT CSV, DELIMITER '|')") # DEL1
    con.execute(f"COPY Delete_Person_likes_Post      TO 'batches/{batch_start_date}/deletes/Person_likes_Post.csv'         (HEADER, FORMAT CSV, DELIMITER '|')") # DEL2
    con.execute(f"COPY Delete_Person_likes_Comment   TO 'batches/{batch_start_date}/deletes/Person_likes_Comment.csv'      (HEADER, FORMAT CSV, DELIMITER '|')") # DEL3
    con.execute(f"COPY Delete_Forum                  TO 'batches/{batch_start_date}/deletes/Forum.csv'                     (HEADER, FORMAT CSV, DELIMITER '|')") # DEL4
    con.execute(f"COPY Delete_Forum_hasMember_Person TO 'batches/{batch_start_date}/deletes/Forum_hasMember_Person.csv'    (HEADER, FORMAT CSV, DELIMITER '|')") # DEL5
    con.execute(f"COPY Delete_Post                   TO 'batches/{batch_start_date}/deletes/Post.csv'                      (HEADER, FORMAT CSV, DELIMITER '|')") # DEL6
    con.execute(f"COPY Delete_Comment                TO 'batches/{batch_start_date}/deletes/Comment.csv'                   (HEADER, FORMAT CSV, DELIMITER '|')") # DEL7
    con.execute(f"COPY Delete_Person_knows_Person    TO 'batches/{batch_start_date}/deletes/Person_knows_Person.csv'       (HEADER, FORMAT CSV, DELIMITER '|')") # DEL8

    ############################# set interval for next iteration ##########################

    batch_start_date = batch_end_date
