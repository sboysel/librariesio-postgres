CREATE INDEX IF NOT EXISTS project_idx ON dependencies (project_id);


CREATE INDEX IF NOT EXISTS dependency_project_idx ON dependencies (dependency_project_id);

WITH RECURSIVE sample AS
  (SELECT d.id,
          d.project_id AS id_i,
          d.dependency_project_id AS id_j,
          d.version_id
   FROM dependencies d
   JOIN projects_core p ON d.project_id = p.id
   OR d.dependency_project_id = p.id
   WHERE dependency_kind = 'runtime'
     AND optional_dependency = FALSE
   UNION SELECT s.id,
                s.id_i,
                s.id_j,
                s.version_id
   FROM sample s
   JOIN dependencies d ON d.project_id = s.id_j -- upstream
   OR d.dependency_project_id = s.id_i -- downstream
   WHERE dependency_kind = 'runtime'
     AND optional_dependency = FALSE)
SELECT *
FROM sample;
