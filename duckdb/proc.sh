#!/bin/bash

set -e

export PATHVAR=`pwd`/../snb-example-graph
export POSTFIX=_0_0.csv

rm -rf ldbc.duckdb
cat schema/raw.sql        | ./duckdb ldbc.duckdb
cat schema/person-*.sql   | ./duckdb ldbc.duckdb
cat schema/edges-*.sql    | ./duckdb ldbc.duckdb
cat schema/entities-*.sql | ./duckdb ldbc.duckdb
cat snb-load.sql      | sed "s|\${PATHVAR}|${PATHVAR}|g" | sed "s|\${POSTFIX}|${POSTFIX}|g" | ./duckdb ldbc.duckdb
#skip batching for now
cat snb-transform.sql | sed "s|:bulkLoadTime|'2014-01-01T00:00:00.000+00:00'|g" | ./duckdb ldbc.duckdb

#cat snb-export.sql    | ./duckdb ldbc.duckdb

# collect data:
#
#                                                 tables for nodes and   tables for person node, 
# <schema>                 = many-to-many edges +   one-to-many edges  + its one-to-many edges,
#                                                   other than person         and attributes
#
# CsvBasic                 = many-to-many edges + basic tables         + person-basic
# CsvComposite             = many-to-many edges + basic tables         + person-composite
# CsvMergeForeign          = many-to-many edges + merge-foreign tables + person-merge-foreign
# CsvCompositeMergeForeign = many-to-many edges + merge-foreign tables + person-composite-merge-foreign

# TODO: load to Neo4j
