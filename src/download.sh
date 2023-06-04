#!/bin/bash

if [ ! -f ./data/$LIBIO_TARGZ ]
then
    curl -o ./data/$LIBIO_TARGZ -C - $LIBIO_URL
fi
