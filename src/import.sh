#!/bin/bash

## (1) download archive to $WORKDIR
if [ ! -f $WORKDIR/$TARGZ ]
then
    curl -o $WORKDIR/$TARGZ -C - $URL
fi

## (2) extract CSV datasets from archive
for d in ${DATASETS[*]}; do
    if [ ! -f $WORKDIR/$d-1.6.0-2020-01-12.csv ]
    then
        echo "Extracting $d..."
        tar -xOf $WORKDIR/$TARGZ \
            libraries-1.6.0-2020-01-12/$d-1.6.0-2020-01-12.csv | \
            # remove header
            tail -n +2 > $WORKDIR/$d-1.6.0-2020-01-12.csv
    fi
done

## (3) copy CSV datasets to postres
for d in ${DATASETS[*]}; do
    ROWS=$($PG -t -c "SELECT COUNT(*) FROM $d;")
    if [ "$ROWS" -eq "0" ]
    then
        echo "Copy $d..."
        $PG -c "\COPY $d FROM '$WORKDIR/$d-1.6.0-2020-01-12.csv' DELIMITER ',' CSV;"
    fi
done
