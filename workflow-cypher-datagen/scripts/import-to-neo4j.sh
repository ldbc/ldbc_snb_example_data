#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

: ${NEO4J_CONTAINER_ROOT:?"Environment variable NEO4J_CONTAINER_ROOT is unset or empty"}
: ${NEO4J_DATA_DIR:?"Environment variable NEO4J_DATA_DIR is unset or empty"}
: ${NEO4J_CSV_DIR:?"Environment variable NEO4J_CSV_DIR is unset or empty"}
: ${NEO4J_VERSION:?"Environment variable NEO4J_VERSION is unset or empty"}
: ${NEO4J_CONTAINER_NAME:?"Environment variable NEO4J_CONTAINER_NAME is unset or empty"}
: ${NEO4J_HEADER_DIR:?"Environment variable NEO4J_HEADER_DIR is unset or empty"}

# make sure directories exist
mkdir -p ${NEO4J_CONTAINER_ROOT}/{logs,import,plugins}

# start with a fresh data dir (required by the CSV importer)
mkdir -p ${NEO4J_DATA_DIR}
rm -rf ${NEO4J_DATA_DIR}/*

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --publish=7474:7474 \
    --publish=7687:7687 \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${NEO4J_CSV_DIR}:/import \
    --volume=${NEO4J_HEADER_DIR}:/headers \
    ${NEO4J_ENV_VARS} \
    neo4j:${NEO4J_VERSION} \
    neo4j-admin import \
    --id-type=INTEGER \
    --nodes=Place="/headers/static/Place.csv,/import/initial_snapshot/static/Place${NEO4J_CSV_POSTFIX}" \
    --nodes=Organisation="/headers/static/Organisation.csv,/import/initial_snapshot/static/Organisation${NEO4J_CSV_POSTFIX}" \
    --nodes=TagClass="/headers/static/TagClass.csv,/import/initial_snapshot/static/TagClass${NEO4J_CSV_POSTFIX}" \
    --nodes=Tag="/headers/static/Tag.csv,/import/initial_snapshot/static/Tag${NEO4J_CSV_POSTFIX}" \
    --nodes=Forum="/headers/dynamic/Forum.csv,/import/initial_snapshot/dynamic/Forum${NEO4J_CSV_POSTFIX}" \
    --nodes=Person="/headers/dynamic/Person.csv,/import/initial_snapshot/dynamic/Person${NEO4J_CSV_POSTFIX}" \
    --nodes=Message:Comment="/headers/dynamic/Comment.csv,/import/initial_snapshot/dynamic/Comment${NEO4J_CSV_POSTFIX}" \
    --nodes=Message:Post="/headers/dynamic/Post.csv,/import/initial_snapshot/dynamic/Post${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_PART_OF="/headers/static/Place_isPartOf_Place.csv,/import/initial_snapshot/static/Place_isPartOf_Place${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_SUBCLASS_OF="/headers/static/TagClass_isSubclassOf_TagClass.csv,/import/initial_snapshot/static/TagClass_isSubclassOf_TagClass${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_LOCATED_IN="/headers/static/Organisation_isLocatedIn_Place.csv,/import/initial_snapshot/static/Organisation_isLocatedIn_Place${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_TYPE="/headers/static/Tag_hasType_TagClass.csv,/import/initial_snapshot/static/Tag_hasType_TagClass${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_CREATOR="/headers/dynamic/Comment_hasCreator_Person.csv,/import/initial_snapshot/dynamic/Comment_hasCreator_Person${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_LOCATED_IN="/headers/dynamic/Comment_isLocatedIn_Country.csv,/import/initial_snapshot/dynamic/Comment_isLocatedIn_Country${NEO4J_CSV_POSTFIX}" \
    --relationships=REPLY_OF="/headers/dynamic/Comment_replyOf_Comment.csv,/import/initial_snapshot/dynamic/Comment_replyOf_Comment${NEO4J_CSV_POSTFIX}" \
    --relationships=REPLY_OF="/headers/dynamic/Comment_replyOf_Post.csv,/import/initial_snapshot/dynamic/Comment_replyOf_Post${NEO4J_CSV_POSTFIX}" \
    --relationships=CONTAINER_OF="/headers/dynamic/Forum_containerOf_Post.csv,/import/initial_snapshot/dynamic/Forum_containerOf_Post${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_MEMBER="/headers/dynamic/Forum_hasMember_Person.csv,/import/initial_snapshot/dynamic/Forum_hasMember_Person${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_MODERATOR="/headers/dynamic/Forum_hasModerator_Person.csv,/import/initial_snapshot/dynamic/Forum_hasModerator_Person${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_TAG="/headers/dynamic/Forum_hasTag_Tag.csv,/import/initial_snapshot/dynamic/Forum_hasTag_Tag${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_INTEREST="/headers/dynamic/Person_hasInterest_Tag.csv,/import/initial_snapshot/dynamic/Person_hasInterest_Tag${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_LOCATED_IN="/headers/dynamic/Person_isLocatedIn_City.csv,/import/initial_snapshot/dynamic/Person_isLocatedIn_City${NEO4J_CSV_POSTFIX}" \
    --relationships=KNOWS="/headers/dynamic/Person_knows_Person.csv,/import/initial_snapshot/dynamic/Person_knows_Person${NEO4J_CSV_POSTFIX}" \
    --relationships=LIKES="/headers/dynamic/Person_likes_Comment.csv,/import/initial_snapshot/dynamic/Person_likes_Comment${NEO4J_CSV_POSTFIX}" \
    --relationships=LIKES="/headers/dynamic/Person_likes_Post.csv,/import/initial_snapshot/dynamic/Person_likes_Post${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_CREATOR="/headers/dynamic/Post_hasCreator_Person.csv,/import/initial_snapshot/dynamic/Post_hasCreator_Person${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_TAG="/headers/dynamic/Comment_hasTag_Tag.csv,/import/initial_snapshot/dynamic/Comment_hasTag_Tag${NEO4J_CSV_POSTFIX}" \
    --relationships=HAS_TAG="/headers/dynamic/Post_hasTag_Tag.csv,/import/initial_snapshot/dynamic/Post_hasTag_Tag${NEO4J_CSV_POSTFIX}" \
    --relationships=IS_LOCATED_IN="/headers/dynamic/Post_isLocatedIn_Country.csv,/import/initial_snapshot/dynamic/Post_isLocatedIn_Country${NEO4J_CSV_POSTFIX}" \
    --relationships=STUDY_AT="/headers/dynamic/Person_studyAt_University.csv,/import/initial_snapshot/dynamic/Person_studyAt_University${NEO4J_CSV_POSTFIX}" \
    --relationships=WORK_AT="/headers/dynamic/Person_workAt_Company.csv,/import/initial_snapshot/dynamic/Person_workAt_Company${NEO4J_CSV_POSTFIX}" \
    --delimiter '|'
