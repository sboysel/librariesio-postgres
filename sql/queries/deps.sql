-- repository IDs for projects in the GitHub public firm sample
CREATE TEMPORARY TABLE repos AS
SELECT DISTINCT
  repository_id,
  id AS project_id,
  repository_name_with_owner AS name_with_owner
FROM 
  projects_with_repository_fields
INNER JOIN 
  public_firm_repos 
  ON 
    projects_with_repository_fields.repository_name_with_owner = public_firm_repos.repo
WHERE 
  repository_host_type = 'GitHub'
ORDER BY 
  repository_name_with_owner,
  id;

CREATE INDEX IF NOT EXISTS project_idx ON repos (project_id);

CREATE TEMPORARY TABLE sample AS
-- get dependency graph for public firm repos
WITH RECURSIVE deps (degree,
                     project_id,
                     dependency_project_id) AS (
  -- base query (not involving deps)
  (
    SELECT DISTINCT
      1 AS degree,
      dependencies.project_id,
      dependencies.dependency_project_id
    FROM
      dependencies
    INNER JOIN
      repos AS p
      ON
        dependencies.project_id = p.project_id
    INNER JOIN
      repos AS d
      ON
        dependencies.dependency_project_id = d.project_id
    WHERE
      project_name != dependency_name AND
      optional_dependency = FALSE AND
      LOWER(dependency_kind) = 'runtime' AND
      dependency_project_id IS NOT NULL
    ORDER BY
      project_id,
      dependency_project_id
  )
  UNION ALL
  -- recursive query (involving deps)
  (
    SELECT
      deps.degree + 1,
      dd.project_id AS project_id,
      dd.dependency_project_id AS dependency_project_id
    FROM
      deps
    INNER JOIN
      -- dependencies in the public firms sample
      (
        SELECT DISTINCT 
          dependencies.project_id,
          dependencies.dependency_project_id
        FROM
          dependencies
        INNER JOIN
          repos AS p
          ON
            dependencies.project_id = p.project_id
        INNER JOIN
          repos AS d
          ON
            dependencies.dependency_project_id = d.project_id
        WHERE
          project_name != dependency_name AND
          dependencies.optional_dependency = FALSE AND
          LOWER(dependencies.dependency_kind) = 'runtime' AND
          dependencies.dependency_project_id IS NOT NULL
      ) AS dd
      ON
        deps.dependency_project_id = dd.project_id
    WHERE
      deps.degree <= 10
    ORDER BY
      dd.project_id,
      dd.dependency_project_id
  )
)
SELECT DISTINCT
  deps.project_id,
  deps.dependency_project_id,
  p.name_with_owner AS project_name_owner,
  d.name_with_owner AS dependency_project_name_owner
FROM deps
LEFT JOIN
  repos AS p
  ON
    deps.project_id = p.project_id
LEFT JOIN
  repos AS d
  ON
    deps.dependency_project_id = d.project_id
WHERE 
  deps.project_id IS NOT NULL AND
  deps.dependency_project_id IS NOT NULL AND
  p.name_with_owner IS NOT NULL AND
  d.name_with_owner IS NOT NULL AND
  p.name_with_owner != d.name_with_owner
ORDER BY
  deps.project_id,
  deps.dependency_project_id;

\COPY sample TO '/home/sam/data/lish/github_contrib/dependency_graph_public_firm_repos.csv' CSV HEADER;
