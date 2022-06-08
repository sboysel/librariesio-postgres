/* Top 100 most starred projects */
SELECT name,
       repository_stars_count,
       repository_url
FROM
  (SELECT DISTINCT ON (repository_url, repository_stars_count) *
   FROM projects_with_repository_fields
   ORDER BY repository_url, repository_stars_count) t
WHERE repository_stars_count IS NOT NULL
ORDER BY repository_stars_count DESC FETCH FIRST 100 ROWS ONLY;
