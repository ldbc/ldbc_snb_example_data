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
    con.execute("DELETE FROM Person_studyAt_University")
    con.execute("DELETE FROM Person_workAt_Company")
    con.execute("DELETE FROM Person_hasInterest_Tag")
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

    # inserts . . . TODO!!!!
    con.execute("""
        INSERT INTO Comment
        SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment
        FROM Raw_Comment
        WHERE creationDate >= ?
          AND deletionDate >= ?""",
        interval)
    # insert nodes
    # con.execute(f"COPY Composite_MergeForeign_Person TO 'batches/{batch_start_date}/insert_Person.csv'  (HEADER, FORMAT CSV, DELIMITER '|')") #1
    # con.execute(f"COPY MergeForeign_Comment          TO 'batches/{batch_start_date}/insert_Comment.csv' (HEADER, FORMAT CSV, DELIMITER '|')") #2
    # con.execute(f"COPY MergeForeign_Post             TO 'batches/{batch_start_date}/insert_Post.csv'    (HEADER, FORMAT CSV, DELIMITER '|')")
    # con.execute(f"COPY MergeForeign_Forum            TO 'batches/{batch_start_date}/insert_Forum.csv'   (HEADER, FORMAT CSV, DELIMITER '|')")

    ######################################## deletes #######################################

    # DEL1
    con.execute("""
        INSERT INTO Delete_Person
        SELECT creationDate, id
        FROM Raw_Person
        WHERE creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL2
    con.execute("""
        INSERT INTO Delete_Person_likes_Post
        SELECT deletionDate, id, likes_Post
        FROM Raw_Person_likes_Post
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL3
    con.execute("""
        INSERT INTO Delete_Person_likes_Comment
        SELECT deletionDate, id, likes_Comment
        FROM Raw_Person_likes_Comment
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL4
    con.execute("""
        INSERT INTO Delete_Forum
        SELECT creationDate, id
        FROM Raw_Forum
        WHERE creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL5
    con.execute("""
        INSERT INTO Delete_Forum_hasMember_Person
        SELECT deletionDate, id, hasMember_Person
        FROM Raw_Forum_hasMember_Person
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL6
    con.execute("""
        INSERT INTO Delete_Post
        SELECT creationDate, id
        FROM Raw_Post
        WHERE creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL7
    con.execute("""
        INSERT INTO Delete_Comment
        SELECT creationDate, id
        FROM Raw_Comment
        WHERE creationDate < ?
          AND deletionDate < ?""",
        interval)

    # DEL8
    con.execute("""
        INSERT INTO Delete_Person_knows_Person
        SELECT deletionDate, Person1id, Person2id
        FROM Raw_Person_knows_Person
        WHERE explicitlyDeleted
          AND creationDate < ?
          AND deletionDate < ?""",
        interval)

    ######################################## export ########################################

    batch_dir = f"batches/{batch_start_date}"
    os.mkdir(batch_dir)
    
    # insert edges

    # delete nodes
    con.execute(f"COPY Delete_Person  TO 'batches/{batch_start_date}/delete_Person.csv'  (HEADER, FORMAT CSV, DELIMITER '|')") # DEL1
    con.execute(f"COPY Delete_Forum   TO 'batches/{batch_start_date}/delete_Forum.csv'   (HEADER, FORMAT CSV, DELIMITER '|')") # DEL4
    con.execute(f"COPY Delete_Post    TO 'batches/{batch_start_date}/delete_Post.csv'    (HEADER, FORMAT CSV, DELIMITER '|')") # DEL6
    con.execute(f"COPY Delete_Comment TO 'batches/{batch_start_date}/delete_Comment.csv' (HEADER, FORMAT CSV, DELIMITER '|')") # DEL7

    # delete edges
    con.execute(f"COPY Delete_Person_likes_Post      TO 'batches/{batch_start_date}/delete_Person_likes_Post.csv'      (HEADER, FORMAT CSV, DELIMITER '|')") # DEL2
    con.execute(f"COPY Delete_Person_likes_Comment   TO 'batches/{batch_start_date}/delete_Person_likes_Comment.csv'   (HEADER, FORMAT CSV, DELIMITER '|')") # DEL3
    con.execute(f"COPY Delete_Forum_hasMember_Person TO 'batches/{batch_start_date}/delete_Forum_hasMember_Person.csv' (HEADER, FORMAT CSV, DELIMITER '|')") # DEL5
    con.execute(f"COPY Delete_Person_knows_Person    TO 'batches/{batch_start_date}/delete_Person_knows_Person.csv'    (HEADER, FORMAT CSV, DELIMITER '|')") # DEL8

    ############################# set interval for next iteration ##########################

    batch_start_date = batch_end_date
