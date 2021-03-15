import duckdb

con = duckdb.connect(database='./ldbc.duckdb', read_only=True)

def run(query_id, query_spec):
    con.execute(query_spec)
    result = con.fetchall()
    print(f"==================== {query_id} ====================")
    print(result)

run("14b", "SELECT country1id, country2id FROM CountryPairs_numFriends ORDER BY frequency DESC LIMIT 10")
