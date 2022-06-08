/* Top 100 most depended upon projects */
SELECT name,
       dependent_repositories_count,
       repository_url
FROM
  (SELECT DISTINCT ON (repository_url, dependent_repositories_count) *
   FROM projects_with_repository_fields
   ORDER BY repository_url, dependent_repositories_count) t
WHERE dependent_repositories_count IS NOT NULL
ORDER BY dependent_repositories_count DESC FETCH FIRST 100 ROWS ONLY;
