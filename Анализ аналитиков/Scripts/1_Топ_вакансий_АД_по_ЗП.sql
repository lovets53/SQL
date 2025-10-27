/*
Вопрос: Какие самые высокооплачиваемые должности аналитика данных?

- Определить 10 самых высокооплачиваемых должностей аналитика данных, которые доступны удаленно и не независимо от места работы.
- Сосредоточиться на объявлениях о вакансиях с указанием зарплаты (удалить нулевые значения).
*/

-- Только для удаленной работы 
SELECT 
	job_id ,
	job_title AS Должность,
	salary_year_avg AS Средняя_ЗП,
	job_posted_date AS Дата_публикации_вакансии,
	job_country AS Страна,
	job_schedule_type AS Тип_работы,
	company_dim.name AS Название_компании
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

--Независимо от места работы
SELECT 
	job_id ,
	job_title AS Должность,
	salary_year_avg AS Средняя_ЗП,
	job_posted_date AS Дата_публикации_вакансии,
	job_country AS Страна,
	job_schedule_type AS Тип_работы,
	company_dim.name AS Название_компании
FROM 
	job_postings_fact 
LEFT JOIN company_dim using(company_id)
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short = 'Data Analyst' 
ORDER BY 
	salary_year_avg DESC
LIMIT 10