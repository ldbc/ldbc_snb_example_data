#!/bin/bash

set -e
set -o pipefail

./duckdb ldbc.duckdb << EOF
    SELECT isPartOf_Country, count(*) AS numPersons
    FROM city
    JOIN person ON person.isLocatedIn_City = city.id
    GROUP BY isPartOf_Country
    ORDER BY numPersons DESC
EOF
