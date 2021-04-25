from neo4j import GraphDatabase, time
from datetime import datetime, date
from dateutil.relativedelta import relativedelta
import time
import pytz
import csv
import re

def query_fun(tx, query_spec, batch):
    result = tx.run(query_spec, batch=batch)
    return result.value()

def run_query(session, query_spec, batch):
    start = time.time()
    result = session.write_transaction(query_fun, query_spec, batch)
    end = time.time()
    duration = end - start

driver = GraphDatabase.driver("bolt://localhost:7687")
session = driver.session()

network_start_date = date(2011, 1, 1)
network_end_date   = date(2014, 1, 1)
batch_size         = relativedelta(years=1)

batch_start_date = network_start_date
while batch_start_date < network_end_date:
    batch_end_date = batch_start_date + batch_size

    interval = [batch_start_date, batch_end_date]
    print(f"batches/{batch_start_date}/")

    for i in range(1, 9):
        print(f"DEL{i}")
        with open(f"cypher/del{i}.cypher", "r") as query_file:
            run_query(session, query_file.read(), str(batch_start_date))

    for i in range(1, 15):
        print(f"INS{i}")
        with open(f"cypher/ins{i}.cypher", "r") as query_file:
            run_query(session, query_file.read(), str(batch_start_date))

    batch_start_date = batch_end_date

session.close()
driver.close()
