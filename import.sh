#!/bin/bash

# echo "Hello, world!"
# echo $(python --version)

LIBIO_TARGZ=libraries-1.6.0-2020-01-12.tar.gz
LIBIO_URL=https://zenodo.org/record/3626071/files/$LIBIO_TARGZ
LIBIO_HOME=$HOME/data/librariesio

if [ ! -f $LIBIO_HOME/$LIBIO_TARGZ ]
then
    curl -o $LIBIO_HOME/$LIBIO_TARGZ $LIBIO_URL
fi

## create schema

# psql -U libio -d libio -a -f schema.sql

# ## import tables

# # [x] projects
# if [ ! -f $LIBIO_PATH/projects.csv ]
# then
#     echo "Extract projects ..."
#     tar -I pigz -xOvf $LIBIO_PATH/libraries-1.6.0-2020-01-12.tar.gz libraries-1.6.0-2020-01-12/projects-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_PATH/projects.csv
#         # sed -e 's/,""/,\\N/g; s/,,/,\\N,/g; s/,,/,\\N,/g; s/,$/,\\N/g; s/"//g' |
#         # csvformat -d ',' -q '"' -U 0 > $LIBIO_PATH/projects.csv 
# fi

# echo "Insert projects ..."

# psql -U libio -d libio -c "COPY projects FROM '$LIBIO_PATH/projects.csv' DELIMITER ',' CSV;"

# # # [x] projects_with_repository_fields
# # if [ ! -f $LIBIO_PATH/projects_with_repository_fields.csv ]
# # then
# #     echo "Extract projects_with_repository_fields ..."
# #     tar -I pigz -xOvf $LIBIO_PATH/libraries-1.6.0-2020-01-12.tar.gz libraries-1.6.0-2020-01-12/projects_with_repository_fields-1.6.0-2020-01-12.csv |
# #         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_PATH/projects_with_repository_fields.csv
# #         # sed -e 's/,""/,\\N/g; s/,,/,\\N,/g; s/,,/,\\N,/g; s/,$/,\\N/g; s/"//g' |
# #         # csvformat -d ',' -q '"' -U 0 > $LIBIO_PATH/projects.csv 
# # fi

# # echo "Insert projects_with_repository_fields ..."

# # psql -U libio -d libio -c "COPY projects_with_repository_fields FROM '$LIBIO_PATH/projects_with_repository_fields.csv' DELIMITER ',' CSV;"

# # [x] dependencies
# if [ ! -f $LIBIO_PATH/dependencies.csv ]
# then
#     echo "Extract dependencies ..."
#     tar -I pigz -xOvf $LIBIO_PATH/libraries-1.6.0-2020-01-12.tar.gz libraries-1.6.0-2020-01-12/dependencies-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_PATH/dependencies.csv
#         # sed -e 's/,""/,\\N/g; s/,,/,\\N,/g; s/,,/,\\N,/g; s/,$/,\\N/g; s/"//g' |
#         # csvformat -d ',' -q '"' -U 0 > $LIBIO_PATH/projects.csv 
# fi

# echo "Insert dependencies ..."

# psql -U libio -d libio -c "COPY dependencies FROM '$LIBIO_PATH/dependencies.csv' DELIMITER ',' CSV;"

# # [x] versions
# if [ ! -f $LIBIO_PATH/versions.csv ]
# then
#     echo "Extract versions ..."
#     tar -I pigz -xOvf $LIBIO_PATH/libraries-1.6.0-2020-01-12.tar.gz libraries-1.6.0-2020-01-12/versions-1.6.0-2020-01-12.csv |
#         csvgrep -c 2 -m NPM | sed '1d' > $LIBIO_PATH/versions.csv
#         # sed -e 's/,""/,\\N/g; s/,,/,\\N,/g; s/,,/,\\N,/g; s/,$/,\\N/g; s/"//g' |
#         # csvformat -d ',' -q '"' -U 0 > $LIBIO_PATH/projects.csv 
# fi

# echo "Insert versions ..."

# psql -U libio -d libio -c "COPY versions FROM '$LIBIO_PATH/versions.csv' DELIMITER ',' CSV;"

# psql -U libio -d libio -c "COPY projects FROM '$LIBIO_PATH/projects.csv' DELIMITER ',' NULL AS '\N' CSV;"
# psql -U libio -d libio -c "COPY projects FROM '$LIBIO_PATH/projects.csv' DELIMITER E'\t' NULL AS '\N' CSV;"

# # psql -U librariesio -d librariesio -c "\copy projects FROM 'projects-1.4.0-2018-12-22.csv' delimiter ',' csv header"
# in2csv -f csv -d ',' -q '"'
# # (1) replace "" with \N (2) replace ,, with \N, multiple times (3) replace empty last column with \N
# sed -i 's/,""/,\\N/g; s/,,/,\\N,/g; s/,,/,\\N,/g; s/,$/,\\N/g' projects-1.4.0-2018-12-22.csv
# # dialect+driver://username:password@host:port/database
# # (4) remove problem entires
# sed -i '/118061,Hackage,ChasingBottoms/d' projects-1.4.0-2018-12-22.csv
# sed -i '/123523,Hackage,proxy-kindness/d' projects-1.4.0-2018-12-22.csv
# sed -i '/124770,Hackage,trace-function-call/d' projects-1.4.0-2018-12-22.csv
# sed -i '/167006,NPM,lm/d' projects-1.4.0-2018-12-22.csv
# sed -i '/184682,Rubygems,britt-geminstaller/d' projects-1.4.0-2018-12-22.csv
# sed -i '/238934,Rubygems,radiant-tags-extension/d' projects-1.4.0-2018-12-22.csv
# sed -i '/241267,Rubygems,RedcapAPI/d' projects-1.4.0-2018-12-22.csv
# sed -i '/249919,Rubygems,serienrenamer/d' projects-1.4.0-2018-12-22.csv
# psql -U librariesio librariesio -c "\copy projects FROM 'projects-1.4.0-2018-12-22.csv' delimiter ',' quote E'\"' null '\N' escape '\' csv header"
# rm projects-1.4.0-2018-12-22.csv

# 	# csvsql -t -q '"' -u 0 --db postgresql://librariesio@localhost/librariesio \
# 	# 	--insert --tables projects --overwrite

# # versions
# echo "Import versions ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/versions-1.4.0-2018-12-22.csv 

# # tags
# echo "Import tags ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/tags-1.4.0-2018-12-22.csv 

# # dependencies
# echo "Import dependencies ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/dependencies-1.4.0-2018-12-22.csv 

# # repositories
# echo "Import repositories ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/repositories-1.4.0-2018-12-22.csv 

# # repository dependencies
# echo "Import repository dependencies ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/repository_dependencies-1.4.0-2018-12-22.csv

# # projects with related repository fields
# echo "Import projects_with_related_repository_fields ..."
# tar -I pigz -xf Libraries.io-open-data-1.4.0.tar.gz --strip-components=1 \
# 	libraries-1.4.0-2018-12-22/projects_with_repository_fields-1.4.0-2018-12-22.csv 

