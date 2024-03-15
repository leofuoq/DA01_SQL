--Bài 1--
SELECT b.CONTINENT, FLOOR(AVG(a.POPULATION)) FROM CITY AS a 
JOIN COUNTRY AS b 
ON a.COUNTRYCODE= b.CODE
GROUP BY b.CONTINENT

--Bài 2--
SELECT 
ROUND((CAST(COUNT(b.email_id)as decimal)/COUNT(a.email_id)),2) as confirm_rate
FROM emails AS a
LEFT JOIN texts AS b
ON a.email_id = b.email_id  AND  b.signup_action = 'Confirmed'

--Bài 3--
SELECT age_bucket,
ROUND(SUM(time_spent) FILTER (WHERE activity_type = 'send') /SUM(time_spent)  * 100.0, 2),
ROUND(SUM(time_spent) FILTER (WHERE activity_type = 'open') /SUM(time_spent) * 100.0, 2) 
FROM activities AS a   
JOIN age_breakdown AS b  
ON a.user_id = b.user_id
WHERE activity_type IN ('open', 'send')
GROUP BY age_bucket

--Bài 4--
SELECT customer_id
FROM customer_contracts as c
join products as p
ON c.product_id =p.product_id
group by c.customer_id
HAVING COUNT(DISTINCT product_category) =3

--Bài 5--
SELECT
a.employee_id,a.name,COUNT(b.employee_id) as reports_count, 
round(avg(b.age)) AS average_age
FROM Employees as a
INNER JOIN Employees as b
ON a.employee_id = b.reports_to
group by a.employee_id
order by a.employee_id

--Bài 6--
SELECT p.product_name, sum(o.unit) AS unit 
FROM Products AS p 
JOIN Orders AS o
ON p.product_id = o.product_id
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY o.product_id
HAVING unit >= 100

--Bài 7--
SELECT a.page_id 
FROM pages AS a 
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.page_id IS NULL;
