from neo4j import GraphDatabase, time
from datetime import datetime
from neo4j.time import DateTime, Date
import time
import pytz
import csv
import re

def query_fun(tx, query_spec, query_parameters):
    result = tx.run(query_spec, query_parameters)
    return result.value()

def run_query(session, query_id, query_spec, query_parameters):
    print(f'Q{query_id}: {query_parameters}')
    start = time.time()
    result = session.read_transaction(query_fun, query_spec, query_parameters)
    print(f'{len(result)} results')
    end = time.time()
    duration = end - start
    #print("Q{}: {:.4f} seconds, {} tuples".format(query_id, duration, result[0]))
    return (duration, result)

driver = GraphDatabase.driver("bolt://localhost:7687")

