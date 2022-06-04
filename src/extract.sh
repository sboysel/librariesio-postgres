#!/bin/bash

# [x] projects
if [ ! -f ./data/projects.csv ]
then
    echo "Extract projects ..."
    tar -I pigz -xOvf ./data/$LIBIO_TARGZ libraries-1.6.0-2020-01-12/projects-1.6.0-2020-01-12.csv |
        csvgrep -c 2 -m NPM | sed '1d' > ./data/projects.csv
fi

# # [x] projects_with_repository_fields
# if [ ! -f $LIBIO_HOME/projects_with_repository_fields.csv ]
# then
#     echo "Extract projects_with_repository_fields ..."
#     tar -I pigz -xOvf $LIBIO_HOME/$LIBIO_TARGZ libraries-1.6.0-2020-01-12/projects_with_repository_fields-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_HOME/projects_with_repository_fields.csv
# fi

# # [x] dependencies
# if [ ! -f $LIBIO_HOME/dependencies.csv ]
# then
#     echo "Extract dependencies ..."
#     tar -I pigz -xOvf $LIBIO_HOME/$LIBIO_TARGZ libraries-1.6.0-2020-01-12/dependencies-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_HOME/dependencies.csv
# fi

# # [x] versions
# if [ ! -f $LIBIO_HOME/versions.csv ]
# then
#     echo "Extract versions ..."
#     tar -I pigz -xOvf $LIBIO_HOME/$LIBIO_TARGZ libraries-1.6.0-2020-01-12/versions-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_HOME/versions.csv
# fi
