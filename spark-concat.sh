#!/bin/bash

set -e
set -o pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./spark-concat.sh <LDBC_DATA_DIRECTORY>"
  echo
  echo "<LDBC_DATA_DIRECTORY> contains the static and dynamic directories for composite-merged-fk data"
  exit 1
fi

# this directory should point to e.g. ~/git/snb/ldbc_snb_datagen/out/sf0.1-raw/csv/raw/composite-merged-fk
LDBC_DATA_DIRECTORY=$1
cd ${LDBC_DATA_DIRECTORY}

cd static
rm -f *.csv
for i in *; do
  tail -qn +2 ${i}/*.csv > ${i}_0_0.csv
done
cd ..

cd dynamic
rm -f *.csv
for i in *; do
  tail -qn +2 ${i}/*.csv > ${i}_0_0.csv
done
cd ..
