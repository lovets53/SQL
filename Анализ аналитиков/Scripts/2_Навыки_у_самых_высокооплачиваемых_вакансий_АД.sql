/*
Вопрос: Какие навыки необходимы для наиболее высокооплачиваемых должностей аналитика данных? 
Как часто встречается навык у топ 10 высокооплачиваемых должностей аналитика данных.

- Использовать топ-10 наиболее высокооплачиваемых должностей аналитика данных из первого запроса
- Добавить конкретные навыки, необходимые для этих должностей.
- Сделать второй запрос, для определения самых востребованных навыков.
- Почему? Это обеспечивает подробный взгляд на то, какие навыки требуются для высокооплачиваемых должностей, помогая соискателям понять, какие навыки развивать, 
чтобы соответствовать высоким зарплатам.
*/

-- Какие навыки необходимы для наиболее высокооплачиваемых должностей аналитика данных работающего удаленно?
WITH top_paiying_vakansiy AS (
SELECT 
	job_id,
	job_title,
	salary_year_avg,
	job_country,
	company_dim.name AS name_company
FROM 
	job_postings_fact 
LEFT JOIN company_dim using(company_id)
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short = 'Data Analyst' AND 
	job_work_from_home = TRUE
ORDER BY 
	salary_year_avg DESC
LIMIT 10
)
SELECT
	job_title AS Должность,
	skills AS Навык,
	salary_year_avg AS Средняя_ЗП,
	job_country AS Страна,
	name_company AS Название_компании
FROM top_paiying_vakansiy
LEFT JOIN skills_job_dim using(job_id)
LEFT JOIN skills_dim using(skill_id)
ORDER BY salary_year_avg DESC;

-- Как часто встречается навык у топ 10 высокооплачиваемых должностей аналитика данных работающего удаленно.
WITH top_paiying_vakansiy AS (
SELECT 
	job_id,
	job_title,
	salary_year_avg,
	job_country,
	company_dim.name AS name_company
FROM 
	job_postings_fact 
LEFT JOIN company_dim using(company_id)
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short = 'Data Analyst' AND 
	job_work_from_home = TRUE
ORDER BY 
	salary_year_avg DESC
LIMIT 10
),
skills_top_paiying_vakansiy AS (
SELECT
	job_title,
	skills,
	salary_year_avg,
	job_country,
	name_company
FROM top_paiying_vakansiy
LEFT JOIN skills_job_dim using(job_id)
LEFT JOIN skills_dim using(skill_id)
ORDER BY salary_year_avg DESC
)
SELECT
	skills AS Навык,
	count(*) AS Количество_Навыков
FROM skills_top_paiying_vakansiy
group BY skills
ORDER BY count(*) DESC;

-- Какие навыки необходимы для наиболее высокооплачиваемых должностей аналитика данных независимо от места работы?
WITH top_paiying_vakansiy AS (
SELECT 
	job_id,
	job_title,
	salary_year_avg,
	job_country,
	company_dim.name AS name_company
FROM 
	job_postings_fact 
LEFT JOIN company_dim using(company_id)
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short = 'Data Analyst'
ORDER BY 
	salary_year_avg DESC
LIMIT 10
)
SELECT
	job_title AS Должность,
	skills AS Навык,
	salary_year_avg AS Средняя_ЗП,
	job_country AS Страна,
	name_company AS Название_компании
FROM top_paiying_vakansiy
LEFT JOIN skills_job_dim using(job_id)
LEFT JOIN skills_dim using(skill_id)
ORDER BY salary_year_avg DESC;

-- Как часто встречается навык у топ 10 высокооплачиваемых должностей аналитика данных независимо от места работы.
WITH top_paiying_vakansiy AS (
SELECT 
	job_id,
	job_title,
	salary_year_avg,
	job_country,
	company_dim.name AS name_company
FROM 
	job_postings_fact 
LEFT JOIN company_dim using(company_id)
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short = 'Data Analyst'
ORDER BY 
	salary_year_avg DESC
LIMIT 10
),
skills_top_paiying_vakansiy AS (
SELECT
	job_title,
	skills,
	salary_year_avg,
	job_country,
	name_company
FROM top_paiying_vakansiy
LEFT JOIN skills_job_dim using(job_id)
LEFT JOIN skills_dim using(skill_id)
ORDER BY salary_year_avg DESC
)
SELECT
	skills AS Навык,
	count(*) AS Количество_Навыков
FROM skills_top_paiying_vakansiy
group BY skills
ORDER BY count(*) DESC;