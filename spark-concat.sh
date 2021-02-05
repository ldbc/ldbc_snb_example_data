#!/bin/bash

set -e
set -o pipefail

cd $1

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
