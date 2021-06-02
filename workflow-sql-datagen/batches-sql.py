import duckdb
from datetime import datetime, date
from dateutil.relativedelta import relativedelta
import time
import pytz
import csv
import re
import sys
import os

# def write_txn_fun(tx, query_spec, batch, csv_file):
#     result = tx.run(query_spec, batch=batch, csv_file=csv_file)
#     return result.value()

# def run_update(session, query_spec, batch, csv_file):
#     start = time.time()
#     result = session.write_transaction(write_txn_fun, query_spec, batch, csv_file)
#     end = time.time()
#     duration = end - start

#     num_changes = result[0]
#     return num_changes

if len(sys.argv) < 2:
    print("Usage: batches-cypher.py <INSERT_DIRECTORY>")
    exit(1)

entities = ["Comment", "Comment_hasTag_Tag", "Forum", "Forum_hasMember_Person", "Forum_hasTag_Tag", "Person", "Person_hasInterest_Tag", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post", "Person_studyAt_University", "Person_workAt_Company", "Post", "Post_hasTag_Tag"]

insert_nodes = ["Comment", "Forum", "Person", "Post"]
insert_edges = ["Comment_hasCreator_Person", "Comment_hasTag_Tag", "Comment_isLocatedIn_Country", "Comment_replyOf_Comment", "Comment_replyOf_Post", "Forum_containerOf_Post", "Forum_hasMember_Person", "Forum_hasModerator_Person", "Forum_hasTag_Tag", "Person_hasInterest_Tag", "Person_isLocatedIn_City", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post", "Person_studyAt_University", "Person_workAt_Company", "Post_hasCreator_Person", "Post_hasTag_Tag", "Post_isLocatedIn_Country"]
insert_entities = insert_nodes + insert_edges

delete_nodes = ["Comment", "Forum", "Person", "Post"]
delete_edges = ["Forum_hasMember_Person", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post"]
delete_entities = delete_nodes + delete_edges

data_dir = sys.argv[1]

con = duckdb.connect(database='ldbc-sql-workflow-test.duckdb')

network_start_date = date(2012, 9, 13)
network_end_date = date(2012, 12, 31)
batch_size = relativedelta(days=1)

batch_start_date = network_start_date
while batch_start_date < network_end_date:
    # format date to yyyy-mm-dd
    batch_id = batch_start_date.strftime('%Y-%m-%d')
    batch_dir = f"batch_id={batch_id}"
    print(f"#################### {batch_dir} ####################")

    print("## Inserts")

    for entity in insert_entities:
        batch_path = f"{data_dir}/inserts/dynamic/{entity}/{batch_dir}"
        if not os.path.exists(batch_path):
            continue

        print(f"{entity}:")
        for csv_file in [f for f in os.listdir(batch_path) if f.endswith(".csv")]:
            csv_path = f"{batch_path}/{csv_file}"
            print(f"- {csv_path}")
            con.execute(f"COPY {entity} FROM '{csv_path}' (DELIMITER '|', HEADER, TIMESTAMPFORMAT '%Y-%m-%dT%H:%M:%S.%g+00:00')")

    # print("## Deletes")
    # for entity in delete_entities:
    #     batch_path = f"{data_dir}/deletes/dynamic/{entity}/{batch_dir}"
    #     if not os.path.exists(batch_path):
    #         continue

    #     print(f"{entity}:")
    #     for csv_file in [f for f in os.listdir(batch_path) if f.endswith(".csv")]:
    #         print(f"- deletes/dynamic/{entity}/{batch_dir}/{csv_file}")


    batch_start_date = batch_start_date + batch_size

con.close()
