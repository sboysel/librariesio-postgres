/* Sample 100 projects in the upper quartile of dependency packages. Write
query result to CSV */
DROP TABLE IF EXISTS projects_sample;


SELECT COUNT(*)
FROM projects_with_repository_fields;

/* Top quartile of projects ranked by total number of dependents as of 2020-01-12 */
CREATE TEMP TABLE tmp AS
  (SELECT id,
          name,
          repository_name_with_owner,
          repository_stars_count,
          dependent_repositories_count,
          repository_url
   FROM
     (SELECT *,
             PERCENT_RANK() OVER (
                                  ORDER BY repository_stars_count) AS r
      FROM
        (SELECT DISTINCT ON(repository_url, repository_stars_count) *
         FROM projects_with_repository_fields
         WHERE repository_stars_count IS NOT NULL
           AND dependent_repositories_count IS NOT NULL
           AND repository_stars_count >= 100
           AND dependent_repositories_count >= 1
           AND repository_fork = FALSE
           AND repository_license IS NOT NULL
           AND repository_readme_filename IS NOT NULL
           AND repository_sourcerank IS NOT NULL
           AND repository_host_type = 'GitHub') j) i
   WHERE r >= 0.75
   ORDER BY repository_stars_count DESC);

/* Count of top quartile dependencies */
SELECT COUNT(*)
FROM tmp;

/* 1% Bernoulli random sample of top quartile dependents */
CREATE TABLE projects_core AS
  (SELECT *
   FROM tmp TABLESAMPLE BERNOULLI (1) REPEATABLE(100));
