WITH RECURSIVE sample AS
  (SELECT d.project_id AS id_i,
          d.dependency_project_id AS id_j,
          1 as level
   FROM deps d
   JOIN (SELECT * FROM proj LIMIT 10) p ON d.project_id = p.id -- upstream
   OR d.dependency_project_id = p.id -- downstream
   UNION SELECT d.project_id AS id_i,
                d.dependency_project_id AS id_j,
                s.level + 1
   FROM sample s
   JOIN deps d ON s.id_j = d.project_id -- upstream
   OR s.id_i = d.dependency_project_id -- downstream
   WHERE s.level < 10) 

SELECT DISTINCT d.id,
       s.id_i,
       s.id_j,
       s.name_i,
       s.name_j,
       s.owner_name_i,
       s.owner_name_j,
       s.url_i,
       s.url_j,
       d.version_id AS ver,
       v.published_timestamp AS t
FROM dependencies d
JOIN (SELECT DISTINCT sample.id_i,
        sample.id_j,
        p_i.name AS name_i,
        p_j.name AS name_j,
        p_i.repository_name_with_owner AS owner_name_i,
        p_j.repository_name_with_owner AS owner_name_j,
        p_i.repository_url AS url_i,
        p_j.repository_url AS url_j
      FROM sample
      LEFT JOIN projects_with_repository_fields p_i ON sample.id_i = p_i.id
      LEFT JOIN projects_with_repository_fields p_j ON sample.id_j = p_j.id) s ON d.project_id = s.id_i AND d.dependency_project_id = s.id_j
JOIN versions v ON d.version_id = v.id
