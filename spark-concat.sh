#!/bin/bash

set -eu
set -o pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./spark-concat.sh <LDBC_DATA_DIRECTORY>"
  echo
  echo "<LDBC_DATA_DIRECTORY> contains the static and dynamic directories for composite-merged-fk data"
  echo
  echo "Concatenates CSV files per type, e.g. the dynamic/Comment/part*.csv files to dynamic/Comment.csv"
  exit 1
fi

# this directory should point to e.g. ~/git/snb/ldbc_snb_datagen/out/sf0.1-raw/csv/raw/composite-merged-fk
LDBC_DATA_DIRECTORY=$1
cd ${LDBC_DATA_DIRECTORY}

rm -f static/*.csv
for i in static/*; do
  echo $i
  tail -qn +2 ${i}/*.csv > ${i}.csv
done

rm -f dynamic/*.csv
for i in dynamic/*; do
  echo $i
  tail -qn +2 ${i}/*.csv > ${i}.csv
done
