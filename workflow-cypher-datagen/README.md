# Cypher workflow using Neo4j

```bash
# concat initial CSV files for loading
export DATA_DIR=~/git/snb/ldbc_snb_datagen/sf0.003/csv/bi/composite-projected-fk/
../spark-concat.sh ${DATA_DIR}/initial_snapshot/

# initialize vars
. scripts/environment-variables-default.sh
export NEO4J_CSV_DIR=${DATA_DIR}

# load
scripts/load-in-one-step.sh

# perform microbatch loading
python3 batches-cypher.py ${DATA_DIR}/ | tee -a my.log
```
