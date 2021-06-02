# Cypher workflow using Neo4j

Generate the data using Datagen:

```bash
tools/build.sh
rm -rf sf${SF}/
tools/run.py ./target/ldbc_snb_datagen_${PLATFORM_VERSION}-${DATAGEN_VERSION}.jar -- --format csv --scale-factor ${SF} --mode bi --explode-edges --output-dir ${SF} 2>&1 | tee log
```

```bash
# set to the desired scale factor and source directory
export SF=0.003
export DATA_DIR=~/git/snb/ldbc_snb_datagen/sf${SF}/csv/bi/composite-projected-fk/

# concat initial CSV files for loading
./spark-concat.sh ${DATA_DIR}/initial_snapshot/

# initialize vars
. scripts/environment-variables-default.sh
export NEO4J_CSV_DIR=${DATA_DIR}

# load
scripts/load-in-one-step.sh

# perform microbatch loading
python3 batches-cypher.py ${DATA_DIR} | tee my.log
```
