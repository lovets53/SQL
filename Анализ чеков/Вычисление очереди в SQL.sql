/*Так как не предаставлена информация, которая четко говорило, что значит очередь, считаю так.
 Если между открытием операции и закрытием прошлой меньше 20 секунд, значит очередь, идут потоком люди. 
Если открытие операции раньше чем закрытие прошлой, значит открылась вторая касса, значит опять очередь.
По периодом,тоже нет никакой информации, что они означают, поэтоум просто считаю для каждого магазина количесnво возникновениz очередей в конкретный месяц, день и час*/


CREATE TEMP TABLE queues as(
WITH time_difference AS (
	SELECT 
		store_id,
		DATE_TRUNC('month',start_operation_dt)::date AS start_month,
		DATE_TRUNC('day',start_operation_dt)::date AS start_day,
		DATE_TRUNC('hours',start_operation_dt) AS start_hours,
		CASE 
			WHEN start_operation_dt - lag(end_operation_dt) OVER(PARTITION BY store_uuid ORDER BY start_operation_dt) < INTERVAL '- 10 minute' THEN 0
			WHEN start_operation_dt - lag(end_operation_dt) OVER(PARTITION BY store_uuid ORDER BY start_operation_dt) < INTERVAL '20 second' THEN 1
			ELSE 0
		END AS flag /*если между открытием текущей операции и закрытием прошлой операции этого же магазина прошло меньше 20 
					секунд или октрытие раньше закрытия, но с разницей не больше 10 минут - пометка.
					Считаю, что если отрылась новая операция, а прошлая не закрывается как минимум 10 минут, техническая проблема, а не очередь*/			
	FROM store_checkout_queues
	JOIN store_stores using(store_uuid)
)
SELECT
	store_id,
	start_month,
	start_day,
	start_hours,
	CASE 
		WHEN flag = 1 AND flag <> lag(flag) over(PARTITION BY store_id) THEN 1
		ELSE 0
	END AS flag -- оставляем тольку первую пометку для каждой очереди, т.е если подряд между 5 операциями открытия и закрытия было меньше 20 секунд, считаем это одной очередью. 
FROM time_difference
)


-- Сколько в магазине было очередей в месяц
SELECT 
	store_id,
	start_month,
	sum(flag) AS cnt_queues
FROM queues
WHERE store_id in (12864064, 98451680)
GROUP BY store_id, start_month
ORDER BY store_id, start_month;

-- Сколько в магазине было очередей в конкретный день
SELECT 
	store_id,
	start_day,
	sum(flag) AS cnt_queues
FROM queues
WHERE store_id in (12864064, 98451680)
GROUP BY store_id, start_day
ORDER BY store_id, start_day;

-- Сколько в магазине было очередей в конкретный день и конретный час
SELECT 
	store_id,
	start_hours,
	sum(flag) AS cnt_queues
FROM queues
WHERE store_id in (12864064, 98451680) 
GROUP BY store_id, start_hours
ORDER BY store_id, start_hours;


-- Очереди по месяцам, от самых нагруженных
SELECT 
	start_month,
	sum(flag) AS cnt_queues
FROM queues
WHERE flag = 1
GROUP BY start_month
ORDER BY cnt_queues desc;


-- Очереди по дням, от самых нагруженных
SELECT 
	start_day,
	sum(flag) AS cnt_queues
FROM queues
WHERE flag = 1
GROUP BY start_day
ORDER BY cnt_queues desc;


-- Пиковые часы
SELECT 
	EXTRACT(HOUR FROM start_hours) AS start_hours,
	count(*) AS cnt_queues
FROM queues
WHERE flag = 1
GROUP BY EXTRACT(HOUR FROM start_hours)
ORDER BY cnt_queues desc;

-- Пиковые часы с учетом дней недели
explain
SELECT 
    TO_CHAR(start_hours, 'Day') as weekday,
    EXTRACT(HOUR FROM start_hours) as hour,
    count(*) as queues_count
FROM queues
--WHERE flag = 1
GROUP BY 
    TO_CHAR(start_hours, 'Day'),
    EXTRACT(HOUR FROM start_hours)
ORDER BY 
    queues_count DESC;