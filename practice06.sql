-- BAI KHO QUA, CHO E XIN THEM MOT CHUT THOI GIAN NHE, TOI NAY A NGU SOM MAI TIET KTL ROI CHECK NHA, YEU ANH--
--Bài 1--
WITH list2 AS (
SELECT company_id	,title, description,count(company_id) 
FROM job_listings
GROUP BY company_id,title, description)
SELECT count(*) FROM list2
WHERE count >1

--Bài 2--
WITH app AS(
SELECT category, product, SUM(spend) AS total_spend 
FROM product_spend
WHERE category = 'appliance'
GROUP BY category, product
order  by  category, product DESC
limit 2),
elec AS(
SELECT category, product, SUM(spend) AS total_spend 
FROM product_spend
WHERE category = 'electronics'
GROUP BY category, product
order  by  category, product DESC
limit 2)
SELECT category, product, total_spend FROM app 
UNION SELECT category, product, total_spend FROM elec


--Bài 3--
WITH list AS (
SELECT policy_holder_id, COUNT(call_received) FROM callers 
GROUP BY policy_holder_id
HAVING COUNT(call_received) >= 3 )
SELECT COUNT(*) FROM list

--Bài 4--
SELECT a.page_id 
FROM pages AS a 
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.page_id IS NULL

--Bài 5-- 
WITH list AS(
SELECT EXTRACT(MONTH FROM event_date) AS month, user_id
FROM user_actions 
GROUP BY month, user_id)

SELECT b.month, count(b.user_id) AS monthly_active_users 
FROM list as a  JOIN list as b 
ON a.month = b.month -1 
AND a.user_id = b.user_id
WHERE b.month = 7
GROUP BY b.month
  
--Bài 6-- 


--Bài 7--
  
--Bài 8--
SELECT customer_id FROM customer 
GROUP BY customer_id
HAVING COUNT(distinct product_key ) = (SELECT count(*) FROM product)

--Bài 9--
SELECT employee_id FROM Employees 
WHERE  salary <30000 
AND manager_id NOT IN (SELECT employee_id FROM Employees )
ORDER BY employee_id

--Bài 10--
WITH list2 AS (
SELECT company_id	,title, description,count(company_id) 
FROM job_listings
GROUP BY company_id,title, description)
SELECT count(*) FROM list2
WHERE count >1

--Bài 11-- need help

--Bài 12--
WITH list AS ((SELECT requester_id AS id FROM RequestAccepted)
UNION ALL (SELECT accepter_id FROM RequestAccepted))
SELECT id, COUNT(id) AS num FROM list
GROUP BY id
ORDER BY COUNT(id) DESC LIMIT 1
