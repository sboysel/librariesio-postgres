#!/bin/bash

LIBIO_TARGZ=libraries-1.6.0-2020-01-12.tar.gz
LIBIO_URL=https://zenodo.org/record/3626071/files/$LIBIO_TARGZ

# if [ ! -f $LIBIO_HOME/$LIBIO_TARGZ ]
if [ ! -f ./data/$LIBIO_TARGZ ]
then
    curl -o ./data/$LIBIO_TARGZ -C - $LIBIO_URL
fi
