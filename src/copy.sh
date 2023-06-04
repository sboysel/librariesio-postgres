#!/bin/bash
export PGPASSWORD=postgres
pg="psql -U postgres -d librariesio -h postgres"
datasets=("dependencies" "projects" "projects_with_repository_fields"
   "respositories" "repository_dependencies" "versions" "tags")

for item in ${datasets[*]}; do
    rows=$($pg -t -c "SELECT COUNT(*) FROM $item;")
    if [ "$rows" -eq "0" ]
    then
        echo "Copy $item..."
        $pg -c "\COPY $item FROM './data/$item-1.6.0-2020-01-12.csv' DELIMITER ',' CSV;"
    fi
done
