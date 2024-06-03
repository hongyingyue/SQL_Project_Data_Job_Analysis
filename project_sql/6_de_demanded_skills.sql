/*
    What are the top 10 in-demand skills for Data Engineer?
*/

-- Solution 1: 2 CTEs

-- WITH job_counts AS (
--     SELECT
--         COUNT(1) AS job_counts
--     FROM 
--         job_postings_fact
--     WHERE
--         job_title_short = 'Data Engineer'
-- ), 
-- skill_counts AS (
--     SELECT 
--         skills,
--         COUNT(skills_job_dim.job_id) AS demand_count
--     FROM job_postings_fact
--     INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
--     INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
--     WHERE
--         job_title_short = 'Data Engineer'
--     GROUP BY
--         skills
--     ORDER BY
--         demand_count DESC
--     LIMIT 10
-- )

-- SELECT
--     skill_counts.skills,
--     skill_counts.demand_count,
--     (skill_counts.demand_count::FLOAT / job_counts.job_counts) * 100 AS demand_percent
-- FROM
--     skill_counts,
--     job_counts;


-- Solution 2: 1 CTE

WITH job_counts AS (
    SELECT
        COUNT(1) AS job_counts
    FROM 
        job_postings_fact
    WHERE
        job_title_short = 'Data Engineer'
)
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND((COUNT(skills_job_dim.job_id) * 1.0 / job_counts.job_counts) * 100, 1)::FLOAT AS demand_percent
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
CROSS JOIN 
    job_counts
WHERE
    job_postings_fact.job_title_short = 'Data Engineer'
GROUP BY
    skills_dim.skills, job_counts.job_counts
ORDER BY
    demand_count DESC
LIMIT 10;
