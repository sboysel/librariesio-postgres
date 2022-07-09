CREATE TABLE IF NOT EXISTS deps AS
SELECT DISTINCT d.project_id,
                d.dependency_project_id
FROM dependencies d
JOIN
 (SELECT id AS version_id
  FROM versions
  WHERE published_timestamp > '2017-01-01') v ON d.version_id = v.version_id
JOIN
 (SELECT id AS project_id
  FROM projects_with_repository_fields
  WHERE repository_stars_count >= 105 -- 90th percentile in terms of stars
  AND sourcerank >= 10 -- 90th percentile in terms of stars
  AND repository_stars_count IS NOT NULL
  AND sourcerank IS NOT NULL
  AND repository_url IS NOT NULL
  AND repository_name_with_owner IS NOT NULL
  AND licenses IS NOT NULL
  AND repository_host_type = 'GitHub') p1 ON d.project_id = p1.project_id
JOIN
 (SELECT id AS project_id
  FROM projects_with_repository_fields
  WHERE repository_stars_count >= 105 -- 90th percentile in terms of stars
  AND sourcerank >= 10 -- 90th percentile in terms of stars
  AND repository_stars_count IS NOT NULL
  AND sourcerank IS NOT NULL
  AND repository_url IS NOT NULL
  AND repository_name_with_owner IS NOT NULL
  AND licenses IS NOT NULL
  AND repository_host_type = 'GitHub') p2 ON d.dependency_project_id = p2.project_id
WHERE d.optional_dependency = FALSE
 AND d.dependency_kind = 'runtime';

CREATE INDEX IF NOT EXISTS project_idxx ON deps (project_id);
CREATE INDEX IF NOT EXISTS dependency_project_idxx ON deps (dependency_project_id); 


CREATE TABLE IF NOT EXISTS proj AS
SELECT p.id
FROM projects_with_repository_fields p
INNER JOIN (SELECT *
            FROM appendix_c_npm_ind_dir_top500_noversion TABLESAMPLE BERNOULLI(20) REPEATABLE(100)
            ORDER BY random()
            LIMIT 100) a ON p.name = a.name;
