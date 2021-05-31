# Cypher workflow using Neo4j

```bash
cd workflow-cypher-datagen

# concat
export DATA_DIR=~/git/snb/ldbc_snb_datagen/sf0.003/csv/bi/composite-projected-fk/initial_snapshot/
../spark-concat.sh ${DATA_DIR}

# initialize vars
. scripts/environment-variables-default.sh

# load
export NEO4J_CSV_DIR=${DATA_DIR}
export NEO4J_CSV_POSTFIX=_0_0.csv
scripts/load-in-one-step.sh
```
