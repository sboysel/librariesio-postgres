#!/bin/bash
WORKDIR=$HOME"/data/librariesio"
TARGZ="libraries-1.6.0-2020-01-12.tar.gz"
URL="https://zenodo.org/record/3626071/files/"$TARGZ
PG="psql -U postgres -d librariesio"
DATASETS=("dependencies" "projects" "projects_with_repository_fields"
   "repositories" "repository_dependencies" "versions" "tags")

# clear any existing tables
$PG < sql/drop.sql

# (re)create tables
$PG < sql/schema.sql

# download
if [ ! -f $WORKDIR/$TARGZ ]
then
    curl -o $WORKDIR/$TARGZ -C - $URL
fi

# extract
for d in ${DATASETS[*]}; do
    if [ ! -f $WORKDIR/$d-1.6.0-2020-01-12.csv ]
    then
        echo "Extracting $d..."
        tar -I pigz -xOf $WORKDIR/$TARGZ \
            libraries-1.6.0-2020-01-12/$d-1.6.0-2020-01-12.csv | \
            tail -n +2 > $WORKDIR/$d-1.6.0-2020-01-12.csv
    fi
done

# copy
for d in ${DATASETS[*]}; do
    ROWS=$($PG -t -c "SELECT COUNT(*) FROM $d;")
    if [ "$ROWS" -eq "0" ]
    then
        echo "Copy $d..."
        $PG -c "\COPY $d FROM '$WORKDIR/$d-1.6.0-2020-01-12.csv' DELIMITER ',' CSV;"
    fi
done

cp ~/repos/tariffs/data/temp/public_firm_repos.csv $WORKDIR/

$PG -c "\COPY public_firm_repos FROM '$WORKDIR/public_firm_repos.csv' DELIMITER ',' CSV HEADER;"
