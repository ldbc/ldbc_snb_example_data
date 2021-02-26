# LDBC SNB Data Converter

[![](https://github.com/ldbc/ldbc_snb_data_converter/workflows/Convert%20data/badge.svg)](https://github.com/ldbc/ldbc_snb_data_converter/actions)

Scripts to convert from **raw graphs** produced by the SNB Datagen to graph data sets using various layouts (e.g. storing edges as merged foreign keys).

We use a mix of Bash, Python, and [DuckDB](https://duckdb.org) SQL scripts to perform these operations.

## Data set

* [Example graph without refresh operations](https://ldbc.github.io/ldbc_snb_docs/example-graph-without-refreshes.pdf)
* [Example graph with refresh operations](https://ldbc.github.io/ldbc_snb_docs/example-graph-with-refreshes.pdf)

The example graph is serialized using the `CsvCompositeMergeForeignRaw` layout which contains the entire temporal graph without filtering/batching.

## Generate data sets

```bash
./spark-concat.sh ${DATAGEN_OUTPUT_DIR}/csv/raw/composite_merge_foreign
mv ${DATAGEN_OUTPUT_DIR}/csv/raw/composite_merge_foreign/dynamic/*.csv data/raw/dynamic
mv ${DATAGEN_OUTPUT_DIR}/csv/raw/composite_merge_foreign/static/*.csv data/raw/static
```

## Processing data sets

To process the data sets, get DuckDB and run the processing script:

```bash
./get.sh
./proc.sh
./rename.sh
./export.sh
```

The `duckdb` directory contains Python and SQL scripts to convert data to other formats (e.g. `CsvComposite` and `CsvMergeForeign`).

To make the schema easier to comprehend, the conversion code performs a bit of extra work, e.g. the `Basic_Person_isLocatedIn_Place` and the `Composite_Person_isLocatedIn_Place` tables are the same. However, the redundancy incurred by this is limited as the number of Persons overall is small.

## Deployed data sets

* [`raw.zip`](https://ldbc.github.io/ldbc_snb_data_converter/raw.zip)
* [`csv-composite-merged-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-composite-merged-fk.zip)
* [`csv-composite-projected-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-composite-projected-fk.zip)
* [`csv-composite-projected-fk-legacy-filenames.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-composite-projected-fk-legacy-filenames.zip)
* [`csv-singular-merged-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-singular-merged-fk.zip)
* [`csv-singular-projected-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-singular-projected-fk.zip)
* [`static-data-projected-fk-separate-labels.zip`](https://ldbc.github.io/ldbc_snb_data_converter/static-data-projected-fk-separate-labels.zip)
* [`csv-only-ids-merged-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-only-ids-merged-fk.zip)
* [`csv-only-ids-projected-fk.zip`](https://ldbc.github.io/ldbc_snb_data_converter/csv-only-ids-projected-fk.zip)

## Test with Neo4j

To test with Neo4j, run the following commands in this repository:

```bash
# set the env vars in this repository
export NEO4J_CSV_DIR=`pwd`/data/csv-composite-projected-fk-legacy-filenames
export NEO4J_CSV_POSTFIX=.csv
```

Then, go to the [`cypher/ directory in the ldbc_snb_implementations repository`](https://github.com/ldbc/ldbc_snb_implementations/tree/dev/cypher) and run:

```bash
. scripts/environment-variables-default.sh
scripts/load-in-one-step.sh
```
