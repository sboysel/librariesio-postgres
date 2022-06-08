/* Sample 100 projects in the upper quartile of dependency packages. Write
query result to CSV */
DROP TABLE IF EXISTS projects_sample;


SELECT COUNT(*)
FROM projects_with_repository_fields;

/* Top quartile of projects ranked by total number of dependents as of 2020-01-12 */
CREATE TEMP TABLE tmp AS
  (SELECT name,
          dependent_repositories_count,
          repository_url
   FROM
     (SELECT *,
             PERCENT_RANK() OVER (
                                  ORDER BY dependent_repositories_count) AS r
      FROM
        (SELECT DISTINCT ON(repository_url, dependent_repositories_count) *
         FROM projects_with_repository_fields) j) i
   WHERE r >= 0.25
     AND dependent_repositories_count IS NOT NULL
   ORDER BY dependent_repositories_count DESC);

/* Count of top quartile dependencies */
SELECT COUNT(*)
FROM tmp;

/* 0.1% Bernoulli random sample of top quartile dependents */
CREATE TABLE projects_core AS
  (SELECT *
   FROM tmp TABLESAMPLE BERNOULLI (0.1) REPEATABLE(100));
