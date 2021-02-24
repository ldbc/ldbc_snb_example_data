#!/bin/bash

set -e
set -o pipefail

# for testing with Neo4j
echo "Change filenames to use lowercase node label names in data/csv-composite-projected-fk-legacy-filenames"

rm -rf data/csv-composite-projected-fk-legacy-filenames/
cp -r data/csv-composite-projected-fk/ data/csv-composite-projected-fk-legacy-filenames/
cd data/csv-composite-projected-fk-legacy-filenames/

if [ -f /etc/redhat-release ]; then
  RENAME=prename
else
  RENAME=rename
fi

${RENAME} -f 's/TagClass_/tagclass_/g' static/*
${RENAME} -f 's/Tag_/tag_/g' static/*
${RENAME} -f 's/TagClass\./tagclass./g' static/*
${RENAME} -f 's/Tag\./tag./g' static/*
${RENAME} -f 's/Place/place/g' static/*
${RENAME} -f 's/Organisation/organisation/g' static/*

${RENAME} -f 's/University/organisation/g' static*
${RENAME} -f 's/Company/organisation/g' static*

${RENAME} -f 's/Comment/comment/g' dynamic/*
${RENAME} -f 's/Post/post/g' dynamic/*
${RENAME} -f 's/Forum/forum/g' dynamic/*
${RENAME} -f 's/Person/person/g' dynamic/*
