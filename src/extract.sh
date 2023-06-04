#!/bin/bash
datasets=("dependencies" "projects" "projects_with_repository_fields"
   "respositories" "repository_dependencies" "versions" "tags")

for item in ${datasets[*]}; do
    if [ ! -f ./data/$item.csv ]
    then
        echo "Extracting $item..."
        tar -I pigz -xOf ./data/$LIBIO_TARGZ \
            libraries-1.6.0-2020-01-12/$item-1.6.0-2020-01-12.csv | \
            tail -n +2 > ./data/$item-1.6.0-2020-01-12.csv
    fi
done
