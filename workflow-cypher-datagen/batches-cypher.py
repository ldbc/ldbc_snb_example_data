from neo4j import GraphDatabase, time
from datetime import datetime, date
from dateutil.relativedelta import relativedelta
import time
import pytz
import csv
import re
import sys
import os

def query_fun(tx, query_spec, batch, csv_file):
    result = tx.run(query_spec, batch=batch, csv_file=csv_file)
    return result.value()

def run_update(session, query_spec, batch, csv_file):
    start = time.time()
    result = session.write_transaction(query_fun, query_spec, batch, csv_file)
    end = time.time()
    duration = end - start

if len(sys.argv) < 2:
    print("Usage: batches-cypher.py <INSERT_DIRECTORY>")
    exit(1)

nodes = ["Comment", "Forum", "Person", "Post"]
edges = ["Comment_hasCreator_Person", "Comment_hasTag_Tag", "Comment_isLocatedIn_Country", "Comment_replyOf_Comment", "Comment_replyOf_Post", "Forum_containerOf_Post", "Forum_hasMember_Person", "Forum_hasModerator_Person", "Forum_hasTag_Tag", "Person_hasInterest_Tag", "Person_isLocatedIn_City", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post", "Person_studyAt_University", "Person_workAt_Company", "Post_hasCreator_Person", "Post_hasTag_Tag", "Post_isLocatedIn_Country"]

insert_queries = {}
for entity in nodes + edges:
    with open(f"cypher/ins-{entity}.cypher", "r") as insert_query_file:
        insert_queries[entity] = insert_query_file.read()

delete_queries = {}
for i in range(1, 9):
    with open(f"cypher/del{i}.cypher", "r") as delete_query_file:
        delete_queries[entity] = delete_query_file.read()

driver = GraphDatabase.driver("bolt://localhost:7687")
session = driver.session()


batch_dir = "batch_id=2012-09-15"
data_dir = sys.argv[1]

print("## Inserts")
for entity in nodes + edges:
    print(f"{entity}:")
    batch_path = f"{data_dir}/inserts/dynamic/{entity}/{batch_dir}"

    if not os.path.exists(batch_path):
        continue

    for csv_file in [f for f in os.listdir(batch_path) if f.endswith(".csv")]:
        print(f"- dynamic/{entity}/{batch_dir}/{csv_file}")
        run_update(session, insert_queries[entity], batch_dir, csv_file)

print("## Deletes")
# TODO


# network_start_date = date(2011, 1, 1)
# network_end_date   = date(2014, 1, 1)
# batch_size         = relativedelta(years=1)

# batch_start_date = network_start_date
# while batch_start_date < network_end_date:
#     batch_end_date = batch_start_date + batch_size

#     interval = [batch_start_date, batch_end_date]
#     print(f"batches/{batch_start_date}/")

#     for i in range(1, 9):
#         print(f"DEL{i}")
#         with open(f"cypher/del{i}.cypher", "r") as query_file:
#             run_query(session, query_file.read(), str(batch_start_date))

#     for i in range(1, 15):
#         print(f"INS{i}")
#         with open(f"cypher/ins{i}.cypher", "r") as query_file:
#             run_query(session, query_file.read(), str(batch_start_date))

#     batch_start_date = batch_end_date

# session.close()
# driver.close()
