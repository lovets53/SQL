/*
1 Вопрос: Каковы наиболее востребованные навыки для аналитиков данных и какая у них средняя ЗП?
2 - Объединить объявления о вакансиях с внутренней связью с таблицей.
3 - Определить топ-10 востребованных навыков для аналитика данных.
4 - Сфокусироваться на всех объявлениях о вакансиях.
5 - Почему? Извлекает топ-10 навыков с самым высоким спросом на рынке труда, предоставляя информацию о наиболее ценных навыках для соискателей.
*/

--Только для удаленной работы
SELECT 
	skills AS Навык,
	count(*) AS Количество_Навыков,
	round(AVG(salary_year_avg),0) AS Средняя_ЗП
FROM job_postings_fact 
JOIN skills_job_dim using(job_id)
JOIN skills_dim using(skill_id)
WHERE 
	job_title_short = 'Data Analyst' AND 
	job_work_from_home = TRUE
GROUP BY skills
ORDER BY count(*) DESC
LIMIT 10

--Независимо от места работы
SELECT 
	skills AS Навык,
	count(*) AS Количество_Навыков,
	round(AVG(salary_year_avg),0) AS Средняя_ЗП
FROM job_postings_fact 
JOIN skills_job_dim using(job_id)
JOIN skills_dim using(skill_id)
WHERE job_title_short = 'Data Analyst' 
GROUP BY skills
ORDER BY count(*) DESC
LIMIT 10