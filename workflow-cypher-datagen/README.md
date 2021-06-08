# Cypher workflow using Neo4j

Generate the data using Datagen. :warning: Make sure the files do not have headers as these are provided separately.

```bash
tools/build.sh
rm -rf sf${SF}/
tools/run.py ./target/ldbc_snb_datagen_${PLATFORM_VERSION}-${DATAGEN_VERSION}.jar -- --format csv --scale-factor ${SF} --mode bi --explode-edges --format-options header=false --output-dir ${SF} 2>&1 | tee log
```

```bash
# set to the desired scale factor and source directory
export SF=0.003
export LDBC_COMPOSITE_PROJECTED_DATA_DIR=~/git/snb/ldbc_snb_datagen/sf${SF}/csv/bi/composite-projected-fk/

# initialize vars
. scripts/environment-variables-default.sh
export NEO4J_CSV_DIR=${LDBC_COMPOSITE_PROJECTED_DATA_DIR}

# load
scripts/load-in-one-step.sh

# perform microbatch loading
python3 batches-cypher.py ${LDBC_COMPOSITE_PROJECTED_DATA_DIR} | tee my.log
```
