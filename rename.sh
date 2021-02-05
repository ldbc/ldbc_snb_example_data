#!/bin/bash

set -e
set -o pipefail

# for testing with Neo4j
echo "Change filenames to use lowercase node label names in csv-composite-projected-fk"

rm -rf data/csv-composite-projected-fk-legacy-filenames/
cp -r data/csv-composite-projected-fk/ data/csv-composite-projected-fk-legacy-filenames/
cd data/csv-composite-projected-fk-legacy-filenames/

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
