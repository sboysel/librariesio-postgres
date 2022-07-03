#!/bin/bash

for item in "projects_with_repository_fields" "dependencies" "versions"; do
    if [ ! -f ./data/$item.csv ]
    then
        echo "Extracting $item..."
        tar -I pigz -xOf ./data/$LIBIO_TARGZ \
            libraries-1.6.0-2020-01-12/$item-1.6.0-2020-01-12.csv | \
            tail -n +2 > ./data/$item-tmp.csv
        echo "Processing $item..."
        # filter to NPM packages
        ./qsvlite search -i -s 2 npm ./data/$item-tmp.csv > ./data/$item.csv
        rm ./data/$item-tmp.csv
    fi
done
