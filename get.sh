#!/bin/bash

set -e
set -o pipefail

export DUCKDB_VERSION=v0.2.4

if [ ! -f duckdb ]; then
    wget https://github.com/cwida/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip -O duckdb_cli-linux-amd64.zip
    unzip -o duckdb_cli-linux-amd64.zip
    rm duckdb_cli-linux-amd64.zip
fi
