#!/bin/bash

start=`date +%s`

echo "dropping tables"
Rscript ./scripts/drop.R
echo  "tables dropped"

echo "loading raw schema"
Rscript ./scripts/raw_schema.R
echo "raw schema loaded"

echo "loading raw data"
Rscript ./scripts/raw_snb_load.R
echo "raw data loaded"

echo "loading composite schema"
Rscript ./scripts/schema.R
echo "composite schema loaded"

echo "convert from raw"
Rscript ./scripts/snb_transform.R
echo "conversion complete"

echo "compute degree per node"
Rscript ./scripts/compute.R
echo "exported to degree.csv"

echo "creating graphics"
Rscript ./scripts/plot.R
echo "graphics created"

end=`date +%s`

runtime=$((end-start))

echo "time taken: $runtime (secs)"
