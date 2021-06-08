# SQL workflow

Generate the data using Datagen:

```bash
tools/build.sh
rm -rf sf${SF}/
tools/run.py ./target/ldbc_snb_datagen_${PLATFORM_VERSION}-${DATAGEN_VERSION}.jar -- --format csv --scale-factor ${SF} --mode bi --output-dir ${SF} 2>&1 | tee log
```

```bash
# set to the desired scale factor and source directory
export SF=0.003
export LDBC_COMPOSITE_MERGED_FK_DATA_DIR=~/git/snb/ldbc_snb_datagen/sf${SF}/csv/bi/composite-merged-fk/

# load and apply microbatches
python3 load.py ${LDBC_COMPOSITE_MERGED_FK_DATA_DIR}
python3 batches.py ${LDBC_COMPOSITE_MERGED_FK_DATA_DIR}
```
