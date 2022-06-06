#!/bin/bash

for item in "projects_with_repository_fields" "dependencies" "versions"; do
    echo "Extracting $item..."
    pv ./data/$LIBIO_TARGZ | \
        tar -I pigz -xOvf - \
            libraries-1.6.0-2020-01-12/$item-1.6.0-2020-01-12.csv |
        ### processing ###
        # qsv behead | \
        sed '1d' | \
        qsv search -i -s 2 npm \
            > ./data/$item.csv
done
