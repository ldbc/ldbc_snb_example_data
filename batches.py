import duckdb
from datetime import date, timedelta
import os

con = duckdb.connect(database='ldbc.duckdb', read_only=False)

start_date = date(2012, 2, 15)
end_date   = date(2012, 2, 16)

delta = end_date - start_date

for i in range(delta.days + 1):
    day = start_date + timedelta(days=i)
    next_day = day + timedelta(days=i)
    print(day)

    interval = [day, next_day]

    # clean insert tables
    con.execute("DELETE FROM MergeForeign_Comment");

    # clean delete tables
    con.execute("DELETE FROM delete_Person");
    con.execute("DELETE FROM delete_Forum");
    con.execute("DELETE FROM delete_Post");
    con.execute("DELETE FROM delete_Comment");
    con.execute("DELETE FROM delete_Person_likes_Comment");
    con.execute("DELETE FROM delete_Person_likes_Post");
    con.execute("DELETE FROM delete_Forum_hasMember_Person");
    con.execute("DELETE FROM delete_Person_knows_Person");

    # inserts
    con.execute("""INSERT INTO MergeForeign_Comment
        SELECT creationDate, id, locationIP, browserUsed, content, length, hasCreator_Person, isLocatedIn_Place, replyOf_Post, replyOf_Comment
        FROM Comment WHERE creationDate >= ? AND deletionDate >= ?""", interval)

    # deletes
    con.execute("""INSERT INTO delete_Person
        SELECT creationDate, id
        FROM Person WHERE creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Forum
        SELECT creationDate, id
        FROM Forum WHERE creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Post
        SELECT creationDate, id
        FROM Post WHERE creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Comment
        SELECT creationDate, id
        FROM Comment WHERE creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Person_likes_Comment
        SELECT deletionDate, id, likes_Comment
        FROM Person_likes_Comment WHERE explicitlyDeleted AND creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Person_likes_Post
        SELECT deletionDate, id, likes_Post
        FROM Person_likes_Post WHERE explicitlyDeleted AND creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Forum_hasMember_Person
        SELECT deletionDate, id, hasMember_Person
        FROM Forum_hasMember_Person WHERE explicitlyDeleted AND creationDate < ? AND deletionDate < ?""", interval)

    con.execute("""INSERT INTO delete_Person_knows_Person
        SELECT deletionDate, Person1id, Person2id
        FROM Person_knows_Person WHERE explicitlyDeleted AND creationDate < ? AND deletionDate < ?""", interval)

    # insert nodes
    # con.execute(f"COPY Composite_MergeForeign_Person TO 'batches/{day}/insert_Person.csv'  (HEADER, FORMAT CSV, DELIMITER '|');") #1
    # con.execute(f"COPY MergeForeign_Comment          TO 'batches/{day}/insert_Comment.csv' (HEADER, FORMAT CSV, DELIMITER '|');") #2
    # con.execute(f"COPY MergeForeign_Post             TO 'batches/{day}/insert_Post.csv'    (HEADER, FORMAT CSV, DELIMITER '|');")
    # con.execute(f"COPY MergeForeign_Forum            TO 'batches/{day}/insert_Forum.csv'   (HEADER, FORMAT CSV, DELIMITER '|');")

    # insert edges

    os.mkdir(f"batches/{day}")

    # delete nodes
    con.execute(f"COPY Delete_Person  TO 'batches/{day}/delete_Person.csv'  (HEADER, FORMAT CSV, DELIMITER '|');") #1
    con.execute(f"COPY Delete_Forum   TO 'batches/{day}/delete_Forum.csv'   (HEADER, FORMAT CSV, DELIMITER '|');") #4
    con.execute(f"COPY Delete_Post    TO 'batches/{day}/delete_Post.csv'    (HEADER, FORMAT CSV, DELIMITER '|');") #6
    con.execute(f"COPY Delete_Comment TO 'batches/{day}/delete_Comment.csv' (HEADER, FORMAT CSV, DELIMITER '|');") #7

    # delete edges
    con.execute(f"COPY Delete_Person_likes_Post      TO 'batches/{day}/delete_Person_likes_Post.csv'      (HEADER, FORMAT CSV, DELIMITER '|');") #2
    con.execute(f"COPY Delete_Person_likes_Comment   TO 'batches/{day}/delete_Person_likes_Comment.csv'   (HEADER, FORMAT CSV, DELIMITER '|');") #3
    con.execute(f"COPY Delete_Forum_hasMember_Person TO 'batches/{day}/delete_Forum_hasMember_Person.csv' (HEADER, FORMAT CSV, DELIMITER '|');") #5
    con.execute(f"COPY Delete_Person_knows_Person    TO 'batches/{day}/delete_Person_knows_Person.csv'    (HEADER, FORMAT CSV, DELIMITER '|');") #8
