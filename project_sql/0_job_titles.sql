/* 
What job titles are included in the database?
 */

-- SELECT DISTINCT
--     job_title_short 
-- FROM 
--     job_postings_fact;

SELECT 
    ROW_NUMBER() OVER (ORDER BY job_title_short) AS row_number,
    job_title_short
FROM 
    (SELECT DISTINCT job_title_short FROM job_postings_fact) AS subquery;