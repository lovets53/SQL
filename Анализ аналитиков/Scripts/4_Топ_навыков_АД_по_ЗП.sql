/*
Вопрос: Какие навыки являются самыми ценными с точки зрения зарплаты? Считаем только для навыков которые встречаются больше 24 раз.
- Рассмотреть среднюю зарплату, связанную с каждым навыком для должностей аналитика данных.
- Фокус на позициях с указанными зарплатами, независимо от местоположения и удаленной работы.
- Почему? Он показывает, как различные навыки влияют на уровень зарплаты аналитиков данных и
помогает выявить наиболее финансово выгодные навыки для приобретения или улучшения.
*/

--Только для удаленной работы
SELECT 
	skills AS Навык,
	round(AVG(salary_year_avg),0) AS Средняя_ЗП,
	count(*) AS Количество_Навыков
FROM job_postings_fact 
JOIN skills_job_dim using(job_id)
JOIN skills_dim using(skill_id)
WHERE 
	salary_year_avg IS NOT NULL AND
	job_title_short = 'Data Analyst' AND 
	job_work_from_home = TRUE
GROUP BY skills
HAVING count(*) >= 25
ORDER BY round(AVG(salary_year_avg),0) DESC
LIMIT 25

--Независимо от места работы
SELECT 
	skills AS Навык,
	round(AVG(salary_year_avg),0) AS Средняя_ЗП,
	count(*) AS Количество_Навыков
FROM job_postings_fact 
JOIN skills_job_dim using(job_id)
JOIN skills_dim using(skill_id)
WHERE 
	salary_year_avg IS NOT NULL AND
	job_title_short = 'Data Analyst'
GROUP BY skills
HAVING count(*) >= 25
ORDER BY round(AVG(salary_year_avg),0) DESC
LIMIT 25