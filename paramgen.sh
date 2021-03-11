#!/bin/bash

set -e
set -o pipefail

./duckdb ldbc.duckdb << EOF
    SELECT ispartof_place, count(*) AS numPersons
    FROM place
    JOIN person ON person.isLocatedIn_Place = place.id
    GROUP BY ispartof_place
    ORDER BY numPersons DESC
EOF
