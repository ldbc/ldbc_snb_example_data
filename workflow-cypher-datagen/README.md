# Cypher workflow using Neo4j

Generate the data using Datagen with the `--explode-edges` and the `--format-options header=false,quoteAll=true` options.

:warning: The format options are important: files should not have headers as these are provided separately (in the `headers/` directory) and quoting the fields in the CSV is required to [preserve trailing spaces](https://neo4j.com/docs/operations-manual/4.2/tools/neo4j-admin-import/#import-tool-header-format).

```bash
tools/build.sh
rm -rf sf${SF}/
tools/run.py ./target/ldbc_snb_datagen_${PLATFORM_VERSION}-${DATAGEN_VERSION}.jar -- --format csv --scale-factor ${SF} --mode bi --explode-edges --format-options header=false,quoteAll=true --output-dir ${SF} 2>&1 | tee log
```

```bash
# set to the desired scale factor and source directory
export SF=0.003
export LDBC_COMPOSITE_PROJECTED_FK_DATA_DIR=~/git/snb/ldbc_snb_datagen/sf${SF}/csv/bi/composite-projected-fk/

# initialize vars
. scripts/environment-variables-default.sh
export NEO4J_CSV_DIR=${LDBC_COMPOSITE_PROJECTED_FK_DATA_DIR}

# load
scripts/load-in-one-step.sh

# perform microbatch loading
python3 batches-cypher.py ${LDBC_COMPOSITE_PROJECTED_FK_DATA_DIR} | tee my.log
```
