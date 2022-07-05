#!/bin/bash
export PGPASSWORD=postgres

pg="psql -U postgres -d librariesio -h postgres"

for item in "projects_with_repository_fields" "dependencies" "versions"; do
    rows=$($pg -t -c "SELECT COUNT(*) FROM $item;")
    if [ "$rows" -eq "0" ]
    then
        echo "Copy $item..."
        $pg -c "\COPY $item FROM './data/$item.csv' DELIMITER ',' CSV;"
    fi
done

table="appendix_c_npm_ind_dir_top500_noversion"
rows=$($pg -t -c "SELECT COUNT(*) FROM $table;")
if [ "$rows" -eq "0" ]
then
    echo "Copy $table..."
    $pg -c "\COPY $table FROM './data/$table.csv' DELIMITER ',' CSV HEADER;"
fi

