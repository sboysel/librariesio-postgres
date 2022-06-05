#!/bin/bash
export PGPASSWORD=postgres

pg="psql -U postgres -d librariesio -h postgres"

echo "Copy projects..."
$pg -c "\COPY projects FROM './data/projects.csv' DELIMITER ',' CSV;"
echo "Copy repositories..."
$pg -c "\COPY repositories FROM './data/repositories.csv' DELIMITER ',' CSV;"
echo "Copy dependencies..."
$pg -c "\COPY dependencies FROM './data/dependencies.csv' DELIMITER ',' CSV;"
echo "Copy versions..."
$pg -c "\COPY versions FROM './data/versions.csv' DELIMITER ',' CSV;"


# [x] projects
output=$($pg -c "\dt projects;")
if ! echo $output | grep -qw "projects";
then
    echo "Copy projects..."
    $pg -c "\COPY projects FROM './data/projects.csv' DELIMITER ',' CSV;"
fi

# [x] repositories
output=$($pg -c "\dt repositories;")
if ! echo $output | grep -qw "repositories";
then
    echo "Copy repositories..."
    $pg -c "\COPY repositories FROM './data/repositories.csv' DELIMITER ',' CSV;"
fi

# # [x] projects_with_repository_fields
# output=$($pg '\dt projects_with_repository_fields;')
# if ! echo $output | grep -qw "projects";
# then
#     $pg -c "\COPY projects_with_repository_fields FROM './data/projects_with_repository_fields.csv' DELIMITER ',' CSV;"
# fi

# [x] dependencies
output=$($pg -c "\dt dependencies;")
if ! echo $output | grep -qw "dependencies";
then
    echo "Copy dependencies..."
    $pg -c "\COPY dependencies FROM './data/dependencies.csv' DELIMITER ',' CSV;"
fi

# [x] versions
output=$($pg -c "\dt versions;")
if ! echo $output | grep -qw "versions";
then
    echo "Copy versions..."
    $pg -c "\COPY versions FROM './data/versions.csv' DELIMITER ',' CSV;"
fi

