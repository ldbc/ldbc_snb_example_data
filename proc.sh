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
echo "Change filenames to use lowercase node label names in csv-composite-projected-fk"

cd data/csv-composite-projected-fk/

if [ -f /etc/redhat-release ]; then
  RENAME=prename
else
  RENAME=rename
fi

${RENAME} -f 's/^TagClass/tagclass/g' *
${RENAME} -f 's/^Tag/tag/g' *
${RENAME} -f 's/TagClass\./tagclass./g' *
${RENAME} -f 's/Tag\./tag./g' *
${RENAME} -f 's/Place/place/g' *
${RENAME} -f 's/Organisation/organisation/g' *

${RENAME} -f 's/University/organisation/g' *
${RENAME} -f 's/Company/organisation/g' *

${RENAME} -f 's/Comment/comment/g' *
${RENAME} -f 's/Post/post/g' *
${RENAME} -f 's/Forum/forum/g' *
${RENAME} -f 's/Person/person/g' *

mkdir -p static
mv {tag,place,organisation}*.csv static
mkdir -p dynamic
mv {comment,post,forum,person}*.csv dynamic
