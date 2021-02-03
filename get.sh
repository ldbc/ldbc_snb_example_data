#!/bin/bash

set -e
set -o pipefail

wget -q https://github.com/cwida/duckdb/releases/download/v0.2.4/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
