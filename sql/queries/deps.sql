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
  id
LIMIT 10;

-- get dependency graph for 
WITH RECURSIVE deps AS (
  -- base query (not involving deps)
  (
    SELECT DISTINCT
      dependencies.project_id,
      dependencies.dependency_project_id
    FROM
      dependencies
    INNER JOIN
      repos
      ON
        dependencies.project_id = repos.project_id
    WHERE
      optional_dependency = FALSE AND
      LOWER(dependency_kind) = 'runtime'
    ORDER BY
      project_id,
      dependency_project_id
  )
  UNION ALL
  -- recursive query (involving deps)
  (
    SELECT DISTINCT
      d.project_id AS project_id,
      d.dependency_project_id AS dependency_project_id
    FROM
      -- dependencies in the public firms sample
      (
        SELECT DISTINCT 
          dependencies.project_id,
          dependencies.dependency_project_id
        FROM
          dependencies
        INNER JOIN
          repos
          ON
            dependencies.dependency_project_id = repos.project_id
        WHERE
          optional_dependency = FALSE AND
          LOWER(dependency_kind) = 'runtime'
      ) AS d
    INNER JOIN
      deps
      ON
        d.project_id = deps.dependency_project_id
    ORDER BY
      project_id,
      dependency_project_id
  )
)
SELECT DISTINCT
  project_id,
  dependency_project_id
FROM deps;
