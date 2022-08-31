# LDBC SNB Data Converter

[![](https://github.com/ldbc/ldbc_snb_data_converter/workflows/Convert%20data/badge.svg)](https://github.com/ldbc/ldbc_snb_data_converter/actions)

Scripts to convert from **raw graphs** produced by the SNB Datagen to graph data sets using various layouts (e.g. storing edges as merged foreign keys).

This repository uses a mix of Bash, Python, and [DuckDB](https://duckdb.org) SQL scripts.
The `get.sh` script installs the Python dependencies and downloads a recent DuckDB binary if it does not exist in the repository directory (the script is automatically invoked by `load.sh`).

If you want to use a custom-built DuckDB binary:
* set the `DUCKDB_PATH` environment variable to the location of the `duckdb` binary (default value: `.`)
* make sure the Python packages has been recompiled (see [instructions](https://github.com/duckdb/duckdb/tree/master/tools/pythonpkg))

## Example data set

The example data set in this repository reflects the toy graphs used in the LDBC SNB:

* [Example graph without updates operations](https://ldbcouncil.org/ldbc_snb_docs/example-graph-without-updates.pdf)
* [Example graph with updates operations](https://ldbcouncil.org/ldbc_snb_docs/example-graph-with-updates.pdf)

The example graph is serialized using the `raw` serializer (composite-merged-fk layout) which contains the entire temporal graph without filtering/batching.

## Generate data sets

Use the data generator in raw mode to generate the data sets. Set the `$LDBC_DATA_DIRECTORY` environment variable to point to the directory of Datagen's output (containing the `static` and `dynamic` directories). Currently, you also have to concatenate the CSVs using the following script.

```bash
DATAGEN_OUTPUT_DIR=TodoSetMe
LDBC_DATA_DIRECTORY=${DATAGEN_OUTPUT_DIR}/csv/raw/composite-merged-fk
./spark-concat.sh ${LDBC_DATA_DIRECTORY}
```

## Processing data sets

To process the data sets, run the following scripts (the first one downloads DuckDB if it's not yet available):

```bash
./load.sh ${LDBC_DATA_DIRECTORY} --no-header
./transform.sh
./export.sh
# optional
./rename.sh
```

The `duckdb` directory contains Python and SQL scripts to convert data to other formats (e.g. `CsvCompositeProjectedFK` and `CsvSingularMergedFK`).

## Deployed data sets

* [`raw.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/raw.zip)
* [`csv-composite-merged-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-composite-merged-fk.zip)
* [`csv-composite-projected-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-composite-projected-fk.zip)
* [`csv-composite-projected-fk-legacy-filenames.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-composite-projected-fk-legacy-filenames.zip)
* [`csv-singular-merged-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-singular-merged-fk.zip)
* [`csv-singular-projected-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-singular-projected-fk.zip)
* [`static-data-projected-fk-separate-labels.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/static-data-projected-fk-separate-labels.zip)
* [`csv-only-ids-merged-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-only-ids-merged-fk.zip)
* [`csv-only-ids-projected-fk.zip`](https://ldbcouncil.org/ldbc_snb_data_converter/csv-only-ids-projected-fk.zip)

## Parameter generation

Run paramgen as follows:

```bash
./load.sh ${LDBC_DATA_DIRECTORY} --no-header
./transform.sh
./factor-tables.sh
./paramgen.sh
```

## Workflows

The `workflow-*` directories test the benchmark workflow, i.e. loading the initial data set, then applying the batches sequentially.
Each batch consists of deletes and inserts.
Currently, the scripts first apply the the deletes, then the inserts.
Note however that the updates can be applied in any order, even interleaved.

### Generating batches

To generate batches and test them, first load the data with a `load.sh` (parameterized for your data set), then run the scripts for producing/loading the data set/batches.

```bash
./load.sh
./transform.sh
./generate-batches.sh
```

* The `transform.sh` script produces the initial snapshot of the data.
* The `generate-batches.sh` script produces batches of a given timespan (e.g. one per year) in the `batches/` directory.

On the example graph:
* The data spans 4 years in the interval 2010-2013 (inclusive on both ends).
* There is one batch per year.
