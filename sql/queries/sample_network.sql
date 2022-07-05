WITH RECURSIVE sample AS
  (SELECT d.id,
          d.project_id AS id_i,
          d.dependency_project_id AS id_j,
          d.version_id
   FROM dependencies d
   JOIN
     (SELECT p.id
      FROM projects_with_repository_fields p
      INNER JOIN appendix_c_npm_ind_dir_top500_noversion a ON p.name = a.name) p ON d.project_id = p.id
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
SELECT s.id,
       s.id_i,
       s.id_j,
       p_i.name AS name_i,
       p_j.name AS name_j,
       p_i.repository_name_with_owner AS owner_name_i,
       p_j.repository_name_with_owner AS owner_name_j,
       p_i.repository_url AS url_i,
       p_j.repository_url AS url_j,
       v.id AS v,
       v.published_timestamp AS t
FROM sample s
LEFT JOIN projects_with_repository_fields p_i ON s.id_i = p_i.id
LEFT JOIN projects_with_repository_fields p_j ON s.id_j = p_j.id
LEFT JOIN versions v ON s.version_id = v.id
