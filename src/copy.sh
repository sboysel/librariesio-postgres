#!/bin/bash

# [x] projects
PGPASSWORD=postgres psql -U postgres -d librariesio -h postgres \
    -c "\COPY projects FROM './data/projects.csv' DELIMITER ',' CSV;"

