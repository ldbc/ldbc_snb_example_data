# SQL workflow using DuckDB

Generate the batches as described in the main [README](../README.md). Then:

```bash
cd workflow-sql
scripts/snapshot-load.sh
scripts/apply-batches.sh
```

* The `snapshot-load.sh` scripts load the initial snapshot of the data.
* The `apply-batches.sh` script loads the initial data set and applies the batches sequentially. 
