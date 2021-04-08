#!/bin/bash

export LDBC_DATA_DIRECTORY=${DATAGEN_OUTPUT_DIR}/csv/raw/composite-merged-fk

echo "=====> spark-concat <====="
./spark-concat.sh ${LDBC_DATA_DIRECTORY}
echo "=====> load <====="
./load.sh ${LDBC_DATA_DIRECTORY} --no-header

echo "=====> transform <====="
./transform.sh
echo "=====> export <====="
./export.sh 

echo "=====> factor tables <====="
/usr/bin/time -v ./factor-tables.sh
echo "=====> paramgen <====="
./paramgen.sh 
