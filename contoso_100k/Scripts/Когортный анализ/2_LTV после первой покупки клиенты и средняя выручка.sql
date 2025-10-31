--title:Выручка с вторых и более покупок и Средняя выручка с вторых и более покупок
SELECT 
	cohort_year,
	count(DISTINCT customerkey) AS customers_count,
	round(sum(total_ner_revenue),2) AS total_ner_revenue,
	round(sum(total_ner_revenue)/count(DISTINCT customerkey),2) AS avg_revenue_after_first_purchase_customer
FROM cogort_analysis 
WHERE orderdate > first_purchase_date 
GROUP BY 
	cohort_year
ORDER BY 
	cohort_year

	
