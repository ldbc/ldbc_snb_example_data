#!/bin/bash

set -e

export PATHVAR=`pwd`/data/raw
export POSTFIX=_0_0.csv

rm -rf ldbc.duckdb
cat schema/raw.sql | ./duckdb ldbc.duckdb
cat schema/composite-merged-fk.sql | ./duckdb ldbc.duckdb
cat snb-load.sql      | sed "s|\${PATHVAR}|${PATHVAR}|g" | sed "s|\${POSTFIX}|${POSTFIX}|g" | ./duckdb ldbc.duckdb
cat snb-transform.sql | sed "s|:bulkLoadTime|'2014-01-01T00:00:00.000+00:00'|g" | ./duckdb ldbc.duckdb

#cat snb-export.sql    | ./duckdb ldbc.duckdb

#
#                                                 tables for nodes and   tables for person node, 
# <schema>                 = many-to-many edges +   one-to-many edges  + its one-to-many edges,
#                                                   other than person         and attributes
#
# CsvBasic                 = many-to-many edges + basic tables         + person-basic
# CsvComposite             = many-to-many edges + basic tables         + person-composite
# CsvMergeForeign          = many-to-many edges + merge-foreign tables + person-merge-foreign
# CsvCompositeMergeForeign = many-to-many edges + merge-foreign tables + person-composite-merge-foreign

# for testing with Neo4j
cd data/csv-composite-projected-fk/
prename -f 's/^TagClass/tagclass/g' *
prename -f 's/^Tag/tag/g' *
prename -f 's/TagClass\./tagclass./g' *
prename -f 's/Tag\./tag./g' *
prename -f 's/Place/place/g' *
prename -f 's/Organisation/organisation/g' *

prename -f 's/University/organisation/g' *
prename -f 's/Company/organisation/g' *

prename -f 's/Comment/comment/g' *
prename -f 's/Post/post/g' *
prename -f 's/Forum/forum/g' *
prename -f 's/Person/person/g' *

mkdir -p static
mv {tag,place,organisation}*.csv static
mkdir -p dynamic
mv {comment,post,forum,person}*.csv dynamic
