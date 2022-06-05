#!/bin/bash
export PGPASSWORD=postgres

pg="psql -U postgres -d librariesio -h postgres"

# [x] projects
output=$($pg '\dt projects;')
if ! echo $output | grep -qw "projects";
then
    $pg -c "\COPY projects FROM './data/projects.csv' DELIMITER ',' CSV;"
fi

# [x] repositories.g
output=$($pg '\dt repositories.g;')
if ! echo $output | grep -qw "repositories.g";
then
    $pg -c "\COPY repositories.g FROM './data/projects.csv' DELIMITER ',' CSV;"
fi

# # [x] projects_with_repository_fields
# output=$($pg '\dt projects_with_repository_fields;')
# if ! echo $output | grep -qw "projects";
# then
#     $pg -c "\COPY projects_with_repository_fields FROM './data/projects_with_repository_fields.csv' DELIMITER ',' CSV;"
# fi

# [x] dependencies
$pg -c "\COPY dependencies FROM './data/dependencies.csv' DELIMITER ',' CSV;"
output=$($pg '\dt dependencies;')
if ! echo $output | grep -qw "dependencies";
then
    $pg -c "\COPY dependencies FROM './data/dependencies.csv' DELIMITER ',' CSV;"
fi

# [x] versions
$pg -c "\COPY versions FROM './data/versions.csv' DELIMITER ',' CSV;"
output=$($pg '\dt versions;')
if ! echo $output | grep -qw "versions";
then
    $pg -c "\COPY versions FROM './data/versions.csv' DELIMITER ',' CSV;"
fi

