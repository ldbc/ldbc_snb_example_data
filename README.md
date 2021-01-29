# LDBC SNB Data Converter

Scripts to convert from raw graphs (produced by Datagen) to graph data sets using various layouts (e.g. storing edges as merged foreign keys).

We use a mix of Bash, Python, and [DuckDB](https://duckdb.org) SQL scripts to perform these operations.

## Data set

The example graph is in `CsvCompositeMergeForeignRaw` format which contains the entire temporal graph without filtering/batching.

## Processing data sets

To process the data sets, get DuckDB and run the processing script:

```bash
./get.sh
./proc.sh
```

The `duckdb` directory contains Python and SQL scripts to convert data to other formats (e.g. `CsvComposite` and `CsvMergeForeign`).

To make the schema easier to comprehend, the conversion code performs a bit of extra work, e.g. the `Basic_Person_isLocatedIn_Place` and the `Composite_Person_isLocatedIn_Place` tables are the same. However, the redundancy incurred by this is limited as the number of Persons overall is small.

## Deployed data sets

* [raw.zip](https://ldbc.github.io/ldbc_snb_data_converter/raw.zip)
* [csv-composite-merged-fk.zip](https://ldbc.github.io/ldbc_snb_data_converter/csv-composite-merged-fk.zip)  
* [csv-composite-projected-fk.zip](https://ldbc.github.io/ldbc_snb_data_converter/csv-composite-projected-fk.zip)  
* [csv-singular-merged-fk.zip](https://ldbc.github.io/ldbc_snb_data_converter/csv-singular-merged-fk.zip)  
* [csv-singular-projected-fk.zip](https://ldbc.github.io/ldbc_snb_data_converter/csv-singular-projected-fk.zip)
