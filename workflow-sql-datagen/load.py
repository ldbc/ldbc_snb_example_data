import duckdb
import sys
import os

print(f"Running DuckDB version {duckdb.__version__}")

print("Datagen / load initial data set using SQL")

if len(sys.argv) < 2:
    print("Usage: batches-sql.py <DATA_DIRECTORY>")
    exit(1)

con = duckdb.connect(database='ldbc-sql-workflow-test.duckdb')

def load_script(filename):
    with open(filename, "r") as f:
        return f.read()

con.execute(load_script("sql/schema-composite-merged-fk.sql"))
con.execute(load_script("sql/schema-delete-candidates.sql"))

print("Load initial snapshot")

# initial snapshot
print("-> Static entities")

PATHVAR="/home/szarnyasg/git/snb/ldbc_snb_datagen/sf1/csv/bi/composite-merged-fk/"

load_static = load_script("sql/snb-load-composite-merged-fk-static.sql") \
    .replace("${PATHVAR}", f"{PATHVAR}/initial_snapshot") \
    .replace("${POSTFIX}", f".csv") \
    .replace("${HEADER}", "")

con.execute(load_static)

print("-> Dynamic entities")

load_static = load_script("sql/snb-load-composite-merged-fk-dynamic.sql") \
    .replace("${PATHVAR}", f"{PATHVAR}/initial_snapshot") \
    .replace("${POSTFIX}", f".csv") \
    .replace("${DYNAMIC_PREFIX}", "dynamic/") \
    .replace("${HEADER}", "")

con.execute(load_static)

print("-> Loaded initial snapshot")
